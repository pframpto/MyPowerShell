break;

$now = Get-Date

$now.ToShortDateString()
$now.ToShortTimeString()
$now.ToUniversalTime()

get-date -Format dd/MM/yy
get-date -Format dd/MM/yyyy
get-date -Format dd/MM/yyyy_HH:mm:ss
$now.AddHours(30)
$now.AddDays(30)
$now.AddDays(-30)
'30/8/2023 14:00' -as [datetime]
'30/8/2023 09:00' -as [datetime]
'30/8/2023 02:00 PM' -as [datetime]

$cutoff = (get-date).AddDays(-30).Date

Get-ChildItem C:\MyGit\BreakScripts -File | where {$_.LastWriteTime -le $cutoff} # all files older than 30 days

