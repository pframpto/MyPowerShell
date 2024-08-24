break;

#check for secret store
get-module microsoft.powershell.secretstore
Find-Module microsoft.powershell.secretstore | install-module

Get-SecretVault
<#
Name    ModuleName                       IsDefaultVault
----    ----------                       --------------
Secrets microsoft.powershell.secretstore True         
#>

Register-SecretVault -Name SecretStore -ModuleName microsoft.powershell.secretstore -DefaultVault

Get-SecretVault
<#
Name        ModuleName                       IsDefaultVault
----        ----------                       --------------
Secrets     microsoft.powershell.secretstore False         
SecretStore microsoft.powershell.secretstore True  
#>

#the default behavour for a secret store is to ask for a password.
#to get around that so you can use it in a script
Set-SecretStoreConfiguration -Authentication None -Interaction None -Confirm:$false
<#
Vault Microsoft.PowerShell.SecretStore requires a password.
Enter password:
A password is no longer required for the local store configuration.
To complete the change please provide the current password.
Enter password:
#>



#Creating a secret
Set-Secret -Name TestSecret -Secret "TestSecretPassword" -Vault SecretStore 

get-secret -Name TestSecret -Vault SecretStore -AsPlainText
<#
TestSecretPassword
#>

#or 
$sec = get-secret -Name TestSecret -Vault SecretStore -AsPlainText

