break;

Import-Module SqlServer

#region get databases on server

Get-SqlDatabase -ServerInstance .\sqlexpress       #This gets the databases on the server.

#endregion

#region read table data
$instance = '.\sqlexpress'
$database = 'Test'
$table = 'desktopItems'
$table = 'Table_1'
$x = Read-SqlTableData -ServerInstance $instance -DatabaseName $database -TableName $table -SchemaName "dbo" -ColumnName item ,number,identifier
Read-SqlTableData -ServerInstance $instance -DatabaseName $database -TableName $table -SchemaName "dbo" | where {$_.id -eq 1}
$x[0].ItemArray[1]
#endregion


#region read sql data view
$instance = '.\sqlexpress'
$database = 'Test'
$view = 'View_1'
$view = 'View_2'

Read-SqlViewData -ServerInstance $instance -DatabaseName $database -SchemaName "dbo" -ViewName $view 

#endregion

#region update table
$instance = '.\sqlexpress'
$database = 'Test'
$table = 'Table_1'

$Insert = @(
	[ordered]@{
        item = 'watch'
        number = 1
		identifier = 3		
	}
    [ordered]@{
        item = 'remote'
        number = 2
		identifier = 4		
	}	
)

$Insert.ForEach({$_.ForEach({[PSCustomObject]$_}) |
	Write-SqlTableData -ServerInstance $Instance -DatabaseName $Database -SchemaName dbo -TableName $Table
	})
#endregion

#region write process information into a new table
$instance = '.\sqlexpress'
$database = 'Test'
$table = 'ProcInfo'

(get-process | select-object -property Id,ProcessName,StartTime,UserProcessorTime,WorkingSet,Description) |
write-SqlTableData -ServerInstance $Instance -DatabaseName $Database -SchemaName 'dbo' -TableName $Table -Force

#endregion

#region write csv to a new table
$instance = '.\sqlexpress'
$database = "Test"
$table = "Users"

Import-CSV -path C:\Scripts\newPowerShell\list.csv | write-sqltabledata -ServerInstance $instance -DatabaseName $database -SchemaName "dbo" -TableName $table -Force

#endregion