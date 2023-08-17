((Get-ADUser "CN=Wei.Choo,OU=Vic,DC=MyCompany,DC=pri").GetEnumerator() | select key).key -join ", " | clip   #This gets the parameters to paste into the select statement

$a = Get-ADUser "CN=Wei.Choo,OU=Vic,DC=MyCompany,DC=pri"  |select DistinguishedName, Enabled, GivenName, Name, ObjectClass, ObjectGUID, SamAccountName, SID, Surname, UserPrincipalName |ConvertTo-Json

$a

$b = ConvertFrom-Json $a 
