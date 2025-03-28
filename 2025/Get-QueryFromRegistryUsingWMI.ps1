$computer = "localhost"
$HKLM = 2147483650
$key = "SOFTWARE\Microsoft\Windows NT\CurrentVersion"
$releaseID = "ReleaseId"
$productName = "ProductName"

$wmi = [wmiclass]"\\$computer\root\default:stdRegProv"
($wmi.GetStringValue($HKLM,$key,$releaseID)).sValue
($wmi.GetStringValue($HKLM,$key,$productName)).sValue