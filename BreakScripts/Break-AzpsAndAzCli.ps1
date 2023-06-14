break
az group list #list our resource groups

Get-AzResourceGroup

$rg = (Get-AzResourceGroup)[0]

# creating a vm in that rg using cli
az vm create --resource-group $rg.ResourceGroupName --location $rg.location --name vm-demo-001 --image UbuntuLTS --admin-username cloudchase --generate-ssh-keys --no-wait

Get-CloudDrive

# gets information about the storage account associated with the cloudshell

<#
PS /home/paul> Get-CloudDrive                                                                                                  

FileShareName      : cloudshell
FileSharePath      : //cloudshell.file.core.windows.net/cloudshell
MountPoint         : /home/paul/clouddrive
Name               : cloudshell
ResourceGroupName  : AZ900RG
StorageAccountName : cloudshell
SubscriptionId     : 9059f657-e0fb-4458-8023-a7b37d02352
#>

Invoke-webrequest -uri “https://raw.githubusercontent/BrentenDovey-ACG/AZZ-104_Azure_Administrator/master/cleanerScript.ps1” -Outfile ~/cleanerScript.ps1
#does not actually work but has the right idea 
#git is already installed in the cloud shell so git clone commands work.

# Create User
az ad user create

new-azureadUser 

