break;

Get-Command –Module ScheduledTasks
<#
CommandType     Name                                               Version    Source                                                                                                                                           
-----------     ----                                               -------    ------                                                                                                                                           
Function        Disable-ScheduledTask                              1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Enable-ScheduledTask                               1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Export-ScheduledTask                               1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Get-ClusteredScheduledTask                         1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Get-ScheduledTask                                  1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Get-ScheduledTaskInfo                              1.0.0.0    ScheduledTasks                                                                                                                                   
Function        New-ScheduledTask                                  1.0.0.0    ScheduledTasks                                                                                                                                   
Function        New-ScheduledTaskAction                            1.0.0.0    ScheduledTasks                                                                                                                                   
Function        New-ScheduledTaskPrincipal                         1.0.0.0    ScheduledTasks                                                                                                                                   
Function        New-ScheduledTaskSettingsSet                       1.0.0.0    ScheduledTasks                                                                                                                                   
Function        New-ScheduledTaskTrigger                           1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Register-ClusteredScheduledTask                    1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Register-ScheduledTask                             1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Set-ClusteredScheduledTask                         1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Set-ScheduledTask                                  1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Start-ScheduledTask                                1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Stop-ScheduledTask                                 1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Unregister-ClusteredScheduledTask                  1.0.0.0    ScheduledTasks                                                                                                                                   
Function        Unregister-ScheduledTask                           1.0.0.0    ScheduledTasks
#>

Get-ScheduledTask -TaskPath "\Microsoft\Windows\WindowsUpdate\" | Get-ScheduledTaskInfo


Get-Command –Module PSScheduledJob
<#
CommandType     Name                                               Version    Source                                                                                                                                           
-----------     ----                                               -------    ------                                                                                                                                           
Cmdlet          Add-JobTrigger                                     1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Disable-JobTrigger                                 1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Disable-ScheduledJob                               1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Enable-JobTrigger                                  1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Enable-ScheduledJob                                1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Get-JobTrigger                                     1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Get-ScheduledJob                                   1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Get-ScheduledJobOption                             1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          New-JobTrigger                                     1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          New-ScheduledJobOption                             1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Register-ScheduledJob                              1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Remove-JobTrigger                                  1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Set-JobTrigger                                     1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Set-ScheduledJob                                   1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Set-ScheduledJobOption                             1.1.0.0    PSScheduledJob                                                                                                                                   
Cmdlet          Unregister-ScheduledJob                            1.1.0.0    PSScheduledJob
#>

$opt = New-ScheduledJobOption –RequireNetwork –RunElevated -WakeToRun
#You don't need to create an option object if you don't want to specify any of its configuration items.

$trigger = New-JobTrigger -Weekly -DaysOfWeek Monday,Thursday -At '3:00PM'


$opt = New-ScheduledJobOption -WakeToRun -RunElevated

$trigger = New-JobTrigger -Once -At (Get-Date).AddMinutes(1)

Register-ScheduledJob -Trigger $trigger -ScheduledJobOption $opt -ScriptBlock { ls C:\temp } -MaxResultCount 5 -Name "LocalDir3"
<#
Id         Name            JobTriggers     Command       Enabled   
--         ----            -----------     -------        -------   
1          LocalDir        1                Dir C:\        True
#>

$param = @{
    ScheduledJobOption = New-ScheduledJobOption -WakeToRun
    Trigger = New-JobTrigger -Once -At (Get-Date).AddMinutes(5)
    ScriptBlock = {dir c:\}
    MaxResultCount = 5
    Name = "LocalDir"
}

Register-ScheduledJob @param


Get-Job

Receive-Job -id 7 -Keep

Get-Job -id 6 | Remove-Job











