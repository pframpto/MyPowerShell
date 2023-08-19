break;
#working with defender
$cimsession1 = "W11OnMac"
Update-MpSignature 
Update-MpSignature -CimSession $cimsession1

#to start a scan
Start-MpScan -ScanType QuickScan

#if there were any threats you can find info on them with
Get-MpThreat

#query defender settings
Get-MpPreference

#for other defender settings
Get-Command -Module ConfigDefender