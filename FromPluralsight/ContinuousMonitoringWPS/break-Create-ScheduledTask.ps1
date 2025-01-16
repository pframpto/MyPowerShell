break;
#### CREATING SCHEDULED TASKS ####

$action = (New-ScheduledTaskAction -Execute "c:\temp\myscript.ps1")
$trigger = New-ScheduledTaskTrigger -Daily -At '10:00 AM'
$principal = New-ScheduledTaskPrincipal -UserId 'w11\pframpto' -RunLevel Highest
$settings = New-ScheduledTaskSettingsSet -RunOnlyIfNetworkAvailable -WakeToRun
$task = New-ScheduledTask -Action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask 'TASK: Query Remote Server Logs' -InputObject $task


