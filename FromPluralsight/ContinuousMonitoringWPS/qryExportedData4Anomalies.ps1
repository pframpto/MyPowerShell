break;
#### Continuous monitoring with PowerShell ###
# SECTION 6 #
## Quering Exported Data For Process or Service Anomalies ##
# Set the Log to Export and Output Location and Filename
$log = "Security"
$logDate = Get-Date -Format yyyyMMddHHmm
$path = "C:\PSFolder\"
$file = ".evtx"
$output = $path + $log + '_' + $logDate + $file

# Export the log
wevtutil.exe epl $log $output

## Example Anomalous Events
# Password spraying via failed logon (Event IDs 4625, 4648 and 4771)
# PowerShell "Net.WebClient" Downloadstring (Event ID 4688)
# Suspicious service creation (Event IDs 4698 and 4699)

# Get Password Spray Entries
Get-WinEvent -FilterHashtable @{LogName = 'Security'; ID = 4648}

# Get PowerShell Download String Entries
Get-WinEvent -FilterHashtable @{LogName = 'security' ; ID = 4688}

# Get Service Creation Entries
Get-WinEvent -FilterHashtable @{LogName = 'security' ; ID = 4698}

# Query Password Spray, PowerShell Download String and Service Creation entries
$eventIDs = 4648,4688,4698
Get-WinEvent -FilterHashtable @{LogName = 'security' ; ID = $eventIDs}


Get-WinEvent -Path C:\PSFolder\Security_202501161252.evtx
Get-WinEvent -FilterHashtable @{Path = 'C:\PSFolder\Security_202501161252.evtx' ; id = 4648}

# Writing queries for eventlogs
Get-WinEvent -FilterHashtable @{LogName = 'Application'}

Get-WinEvent -FilterHashtable @{LogName = 'Application'; ID = 4688}

$date = (Get-Date).AddDays(-1)
Get-WinEvent -FilterHashtable @{LogName = 'Application'; StartTime = $date; ID = 4688}

Get-WinEvent -FilterHashtable @{
    LogName = 'Application'
    ProviderName = 'Application Error'
    Data = 'Calc.exe'
}

## Where-Object
# Get Security Log Entries with an ID of 4688
Get-WinEvent -LogName security | Where-Object {$_.Id -eq 4688}

# Get Security log entries created in the last 24hrs
$date = (get-date) - (New-TimeSpan -Days 1)
Get-WinEvent -LogName security | Where-Object {$_.TimeCreated -gt $date}

# Get Security log entries with an id of 4688 Created in the last 30 days
$eventIDs = 4648,4688,4698
$date = (get-date) - (New-TimeSpan -Days 30)
Get-WinEvent -LogName security |
Where-Object {$_.TimeCreated -gt $date -and $_.id -in $eventIDs}

## FilerXML

# Get Security Events by ID 4688
$query = @'
    <QueryList>
        <Query Id='0' Path="Security">
            <Select Path="Security">
                *[System[(EventID='4688')]]
            </Select>
        </Query>
    </QueryList>
'@
Get-WinEvent -FilterXml $query

## FilterXPath

# Get Security Events by ID 4688
$xpath = "*[System[(EventID='4688')]]"
Get-WinEvent -LogName security -FilterXPath $xpath

# Get Security Events Created in the last 24hrs
$xpath = "*[System[EventID = '4688' and TimeCreated[timediff(@SystemTime) <= 86400000]]]"
Get-WinEvent -LogName "Security" -FilterXPath $xpath