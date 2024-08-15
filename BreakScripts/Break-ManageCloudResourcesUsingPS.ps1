break;
#region Review Azure PowerShell

##Review the benefits of the Azure PowerShell module

##Install the Azure PowerShell module

# Methods to install the Az PowerShell module
<#
The Install-Module cmdlet
Azure PowerShell MSI
Az PowerShell Docker container
#>
Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force



#Az PowerShell Docker container
<#
docker pull mcr.microsoft.com/azure-powershell
docker run -it mcr.microsoft.com/azure-powershell pwsh
#>

#To sign in to Azure from Azure PowerShell
Connect-AzAccount

##Migrate Azure PowerShell from AzureRM to Azure
# The recommended option to migrate from AzureRM to the Az PowerShell module is to use automatic migration.
Install-Module -Name Az.Tools.Migration

##Review Microsoft Azure Active Directory module for Windows PowerShell and Azure Active Directory PowerShell for Graph modules
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
Install-Module Microsoft.Graph

# Connecting to Microsoft Entra ID with PowerShell
Connect-MgGraph -Scopes 'User.Read.All'

#endregion

#region Review the features and tools for Azure Cloud Shell

##Review the characteristics of Azure Cloud Shell
az account show
Get-AzSubscription

##Review the features and tools of Azure Cloud Shell

##Configure and experiment with Azure Cloud Shell

Get-AzSubscription
Get-AzResourceGroup

az resource list

#endregion

#region Manage Azure resources with Windows PowerShell

##Create a new Azure virtual machine by using Windows PowerShell commands

#To create an Azure VM, you need to perform the following tasks:
<#
Create a resource group.
Create an Azure VM.
Connect to the Azure VM.
#>

#Create a resource group
New-AzResourceGroup -ResourceGroupName "myResourceGroup" -Location "westeurope"

#Create an Azure VM
$cred = Get-Credential

$vmParams = @{
  ResourceGroupName = 'myResourceGroup'
  Name = 'TestVM'
  Location = 'westeurope'
  ImageName = 'Win2016Datacenter'
  PublicIpAddressName = 'TestPublicIp'
  Credential = $cred
  OpenPorts = 3389
}

New-AzVM @vmParams

#or
New-AzVm -ResourceGroupName "myResourceGroup"
    -Name "myVM"
    -Location "EastUS"
    -VirtualNetworkName "myVnet"
    -SubnetName "mySubnet"
    -SecurityGroupName "myNetworkSecurityGroup"
    -PublicIpAddressName "myPublicIpAddress"
    -Credential $cred

#Connect to the Azure VM
Get-AzPublicIpAddress -ResourceGroupName "myResourceGroup"  | Select IpAddress

mstsc /v:<publicIpAddress>

##Manage Azure virtual machines by using Windows PowerShell commands
# To review a list of VM sizes available in a particular region, use the Get-AzVMSize command. For example:

Get-AzVMSize -Location "EastUS"

Get-AzVMSize -ResourceGroupName "myResourceGroup" -VMName "myVM" #finds the size of this vm

#The following example depicts how to change VM size to the Standard_DS3_v2 size profile:

$vm = Get-AzVM -ResourceGroupName "myResourceGroupVM" -VMName "myVM"
$vm.HardwareProfile.VmSize = "Standard_DS3_v2"
Update-AzVM -VM $vm -ResourceGroupName "myResourceGroup"

#To stop and deallocate a VM with Stop-AzVM, you can run the following command:
Stop-AzVM -ResourceGroupName "myResourceGroup" -Name "myVM" -Force

#To start a VM, you can run the following command:

Start-AzVM -ResourceGroupName "myResourceGroup" -Name "myVM"

#If you want to delete everything inside of a resource group, including VMs, you can run the following command:

Remove-AzResourceGroup -Name "myResourceGroupVM" -Force

#To add a data disk to an Azure VM after you create it, you need to define disk configuration by using the New-AzDiskConfig command. 
#  You then need to use the New-AzDisk and Add-AzVMDataDisk commands to add a new disk to the VM, as the following example depicts:

$diskConfig = New-AzDiskConfig -Location "EastUS" -CreateOption Empty -DiskSizeGB 128
$dataDisk = New-AzDisk -ResourceGroupName "myResourceGroupDisk" -DiskName "myDataDisk" -Disk $diskConfig

$vm = Get-AzVM -ResourceGroupName "myResourceGroupDisk" -Name "myVM"
$vm = Add-AzVMDataDisk -VM $vm -Name "myDataDisk" -CreateOption Attach -ManagedDiskId $dataDisk.Id -Lun 1

Update-AzVM -ResourceGroupName "myResourceGroupDisk" -VM $vm

##Manage Azure related storage by using Azure PowerShell

#Use the following example to create a storage account called mystorageaccount with LRS and blob encryption, which is enabled by default.

$storageAccount = New-AzStorageAccount -ResourceGroupName $resourceGroup -Name "mystorageaccount" -SkuName Standard_LRS -Location $location 

$ctx = $storageAccount.Context

$containerName = "quickstartblobs"
New-AzStorageContainer -Name $containerName -Context $ctx -Permission blob

#to set the storage account type you should use the following command:
Set-AzStorageAccount -ResourceGroupName "MyResourceGroup" -AccountName "mystorageaccount" -Type "Standard_RAGRS"

#To set custom domain for existing storage account, you can use the following command:

Set-AzStorageAccount -ResourceGroupName "MyResourceGroup" -AccountName "mystorageaccount" -CustomDomainName "www.contoso.com" -UseSubDomain $True

##Manage Azure subscriptions by using Azure PowerShell

#To get all Azure subscriptions active on all tenants, run the following command:

Get-AzSubscription
<#
Name                               Id                      TenantId                        State
----                               --                      --------                        -----
Subscription1                      yyyy-yyyy-yyyy-yyyy     aaaa-aaaa-aaaa-aaaa             Enabled
Subscription2                      xxxx-xxxx-xxxx-xxxx     aaaa-aaaa-aaaa-aaaa             Enabled
Subscription3                      zzzz-zzzz-zzzz-zzzz     bbbb-bbbb-bbbb-bbbb             Enabled
#>

#To focus on subscriptions assigned to a specific tenant, run the following command:

Get-AzSubscription -TenantId "aaaa-aaaa-aaaa-aaaa"
<#
Name                               Id                      TenantId                        State
----                               --                      --------                        -----
Subscription1                      yyyy-yyyy-yyyy-yyyy     aaaa-aaaa-aaaa-aaaa             Enabled
Subscription2                      xxxx-xxxx-xxxx-xxxx     aaaa-aaaa-aaaa-aaaa             Enabled
#>

#The Set-AzContext cmdlet sets authentication information for cmdlets that you run in the current session. The context includes tenant, subscription, and environment information.

#To set the subscription context, run the following command:

Set-AzContext -Subscription "xxxx-xxxx-xxxx-xxxx"
<#
Name    Account             SubscriptionName    Environment         TenantId
----    -------             ----------------    -----------         --------
Work    test@outlook.com    Subscription1       AzureCloud          xxxxxxxx-x...
#>

#The next example depicts how to get a subscription in the currently active tenant and set it as the active session:
$context = Get-AzSubscription -SubscriptionId ...
Set-AzContext $context





