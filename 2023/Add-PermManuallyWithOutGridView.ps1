# Find the folder you want to change permissions on an copy it to the clipboard.

$L = Get-Clipboard

#$L = "\\Server1\Share\InterestingFolder"
$NewL = $L.Replace("\\Server1\shared\","\\Server2\Shared\")
Get-NTFSAccess $NewL  |Format-Table -AutoSize
"================================================================================================================================================================"
$accounts = Get-NTFSAccess $l -ExcludeInherited | Where-Object {$_.Account -like "mycompany\*"} | Out-GridView -PassThru -Title $NewL

foreach($account in $accounts){
    
    Add-NTFSAccess -Path $NewL -Account $account.Account.AccountName -AccessRights $account.AccessRights -AccessType Allow -InheritanceFlags $account.InheritanceFlags -PassThru
    "============================================================================================================================================================="
}

