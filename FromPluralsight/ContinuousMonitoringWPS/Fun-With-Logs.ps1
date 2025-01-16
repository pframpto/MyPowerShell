break;
####   Retrieve Windows Event Log Entries ####
# Retrieve All Event Logs
Get-WinEvent -ListLog *

# Retrieve Event Logs with Entries
Get-WinEvent -ListLog * | Where-Object -Property recordCount -GT 0

# Retrieve Entries from Security Event Log
Get-WinEvent -LogName Security
Get-WinEvent -LogName Security -MaxEvents 5 | Select-Object -Property *

#### FILTERING WINDOWS EVENT LOG ENTRIES
# Retrieve Entries and Filter by ID
Get-WinEvent -LogName Security | Where-Object -Property id -EQ 4624

# Retrieve Entries and filter by ID using Hash Table
Get-WinEvent -FilterHashtable @{ LogName='Security'; ID=4624}

# Retrieve Entries and Filter by ID using hast table with variables
$logname = "Security"
$StartDate = ""
$endDate = ""
Get-WinEvent -FilterHashtable @{
    LogName = $logname;
    StartTime = $StartDate;
    EndTime = $endDate
}








