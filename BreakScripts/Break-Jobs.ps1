break
# start local jobs


start-job -ScriptBlock {ls -Recurse C:\temp} -Name RecurseTemp

Start-Job -FilePath C:\MyScripts\test.ps1 -Name test

#remote jobs

Invoke-Command -ScriptBlock {Get-EventLog -LogName System -Newest 10 } -AsJob -JobName remoteLogs -ComputerName wsa12345, wsa23456

Start-Job  -ScriptBlock {Get-CimInstance -ClassName Win32_ComputerSystem}
<#
Id     Name  PSJobTypeName  State   HasMoreData  Location   Command                  
--     ----  -------------  -----   -----------  --------   -------                  
3      Job3  BackgroundJob  Running True         localhost  Get-CimInstance -Class..
#>

Get-WmiObject -Class win32_computersystem -AsJob

Get-Job
<#
Id     Name            PSJobTypeName   State         HasMoreData     Location
--     ----            -------------   -----         -----------     --------
2      LocalDirectory  BackgroundJob   Running       True            localhost
4      TestScript      BackgroundJob   Completed     True            localhost
6      RemoteLogs      RemoteJob       Failed        True            LON-DC1...
10     Job10           WmiJob          Failed        False           localho...
#>
Get-Job -Name TestScript
<#
Id     Name            PSJobTypeName   State         HasMoreData     Location
--     ----            -------------   -----         -----------     --------
4      TestScript      BackgroundJob   Completed     True            localhost
#>
Get-Job -ID 5
<#
Id     Name            PSJobTypeName   State         HasMoreData     Location
--     ----            -------------   -----         -----------     --------
5      Job5                            Completed     True            localhost
#>

Get-Job -Name RemoteJobs -IncludeChildJobs
<#   
Id     Name            PSJobTypeName   State         HasMoreData     Location
--     ----            -------------   -----         -----------     --------
7      Job7                            Failed        False           LON-DC1
8      Job8                            Completed     True            LON-CL1
9      Job9                            Failed        False           LON-SVR1
#>

Get-Job -Name RemoteLogs | Select -ExpandProperty ChildJobs
<#
Id     Name            PSJobTypeName   State         HasMoreData     Location
--     ----            -------------   -----         -----------     --------
7      Job7                            Failed        False           LON-DC1
8      Job8                            Completed     True            LON-CL1
9      Job9                            Failed        False           LON-SVR1
#>

Receive-Job –ID 13 -Keep | Format-Table –Property Name,Length













































