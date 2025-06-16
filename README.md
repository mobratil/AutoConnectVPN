# AutoConnectVPN

This PowerShell script automatically connects to a specified VPN on Windows.  
It helps in corporate environments where group policy prevents VPNs from connecting automatically.

The script runs in a loop, checking every 60 seconds if any VPN is connected. If not, it connects using `rasdial`.

## Features

- Automatically connects to a VPN if disconnected
- Can run silently in the background
- Easy setup as a scheduled task

## Usage

```powershell
.\AutoConnectVPN.ps1 -VpnName My-Manual-VPN
```

## Run on Windows Logon
To run the script automatically when you log in:
> ⚠️ You should run the following commands in a PowerShell **window with Administrator privileges**.
> 
> 🛠 Make sure to update the -File path to where your script is stored and the -VpnName.

```powershell
$Trigger = New-ScheduledTaskTrigger -AtLogOn
$Action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument '-WindowStyle Hidden -File C:\GIT\AutoConnectVPN\AutoConnectVPN.ps1 -VpnName My-Manual-VPN'
Register-ScheduledTask -TaskName "AutoConnectVPN" -Trigger $Trigger -Action $Action
schtasks /Run /TN "AutoConnectVPN"    # To run newly created task
```

## Manage Scheduled Tasks (UI)
1) Press Win + R, type taskschd.msc, and press Enter.
2) In the Task Scheduler, navigate to Task Scheduler Library.
3) Look for the task named AutoConnectVPN.