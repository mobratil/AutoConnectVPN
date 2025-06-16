param (
    [Parameter(Mandatory=$true)]
    [string]$VpnName,
    [string]$LogFile
)

if ($LogFile) {
    Start-Transcript -Path $LogFile -Append -Force
}

function Log {
    param ($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Output "[$timestamp] $message"
}

function LogError {
    param ($message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Write-Error "[$timestamp] $message"
}

function Is-AnyVpnConnected {
    $output = rasdial 2>&1
    return -not ($output -match "No connections")
}

while ($true) {
    try {
        if (Is-AnyVpnConnected) {
            Log "VPN is already connected."
        } else {
            Log "No VPN connection found. Running rasdial '$VpnName'..."
            $output = rasdial $VpnName 2>&1
            foreach ($line in $output) {
                Log $line
            }
        }
    }
    catch {
        LogError "Exception: $_"
    }

    Start-Sleep -Seconds 60
}

if ($LogFile) {
    Stop-Transcript
}
