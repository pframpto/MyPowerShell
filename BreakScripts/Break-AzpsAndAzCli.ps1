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

#create a resource group and an azure managed disk by using azure cli
LOCATION=$(az group show --name 'paulsrg' --query location --out tsv)
RGNAME='paulsrg2'
az group create --name $RGNAME --location $LOCATION
# to retreive the properties of this RG
az group show --name $RGNAME

# next create a managed disk with the same properties.
DISKNAME='az104-03d-disk1'

az disk create --resource-group $RGNAME --name $DISKNAME --sku 'Standard_LRS' --size-gb 32

# next retrieve the properties of the newly created disk.
az disk show --resource-group $RGNAME --name $DISKNAME

# Task3 Configure the managed disk by using Azure CLI
# increase the size of the disk to 64Gb

az disk update --resource-group $RGNAME --name $DISKNAME --size-gb 64

# verify that the change took effect
az disk show --resource-group $RGNAME --name $DISKNAME --query diskSizeGb 

# change the disk performance sku to premium lrs

az disk update --resource-group $RGNAME --name $DISKNAME --sku 'Premium_LRS'

# verify that the change took effect
az disk show --resource-group $RGNAME --name $DISKNAME --query sku 

# Delete Resouce groups with powershell

Remove-AzResourceGroup -Name "ContosoRG01"

#connect to azure
Connect-AzAccount  

#Use the Get-AzContext cmdlet to determine which subscription is active.
Get-AzContext

#Change the subscription by passing the name of the one to select.
Set-AzContext -Subscription '00000000-0000-0000-0000-000000000000'

#You can retrieve a list of all Resource Groups in the active subscription.
Get-AzResourceGroup
Get-AzResourceGroup | Format-Table
(Get-AzResourceGroup).ResourceGroupName
#Create a resource group

New-AzResourceGroup -Name MyPSCreatedResourceGroup -Location "australia east"

#Create an Azure Virtual Machine
#Azure PowerShell provides the New-AzVm cmdlet to create a virtual machine.
New-AzVm -ResourceGroupName MyPSCreatedResourceGroup -Name MyPowerShellCreatedVM -Credential (Get-Credential) -Location "Australia East" -Image CentOS -PublicIpSku Basic -PublicIpAddressName testPip

# Remove-AzVM	Deletes an Azure VM.
# Start-AzVM	Start a stopped VM.
# Stop-AzVM	    Stop a running VM.
# Restart-AzVM	Restart a VM.
# Update-AzVM	Updates the configuration for a VM.

Remove-AzVM -Name MyPowerShellCreatedVM -ResourceGroupName MyPSCreatedResourceGroup

$vm = Get-AzVM  -Name MyPowerShellCreatedVM -ResourceGroupName MyPSCreatedResourceGroup

# $ResourceGroupName = "ExerciseResources"
# $vm = Get-AzVM  -Name MyVM -ResourceGroupName $ResourceGroupName
# $vm.HardwareProfile.vmSize = "Standard_DS3_v2"

# Update-AzVM -ResourceGroupName $ResourceGroupName  -VM $vm

#What I entered into the sandbox
New-AzVm -ResourceGroupName learn-dc059acd-c63c-4aa7-ac70-0b7376e9f04c -Name "testvm-eus-01" -Credential (Get-Credential) -Location "eastus" -Image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest -OpenPorts 22 -PublicIpAddressName "testvm-01"
$vm = (Get-AzVM -Name "testvm-eus-01" -ResourceGroupName learn-dc059acd-c63c-4aa7-ac70-0b7376e9f04c)
$vm.HardwareProfile
$vm.StorageProfile.OsDisk
#running the following command will show you all available sizes for your VM:
$vm | Get-AzVMSize
$vm | Get-AzVMSize | where {$_.MemoryInMB -eq 8192}

#to get your public IP address:
Get-AzPublicIpAddress -ResourceGroupName learn-dc059acd-c63c-4aa7-ac70-0b7376e9f04c -Name "testvm-01"

#Shutting down the VM
Stop-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName

#Delete a VM
Remove-AzVM -Name $vm.Name -ResourceGroupName $vm.ResourceGroupName

#Run this command to list all the resources in your resource group:
Get-AzResource -ResourceGroupName $vm.ResourceGroupName | Format-Table

#Delete the network interface:
$vm | Remove-AzNetworkInterface –Force

#Delete the managed OS disks:
Get-AzDisk -ResourceGroupName $vm.ResourceGroupName -DiskName $vm.StorageProfile.OSDisk.Name | Remove-AzDisk -Force

#delete the virtual network:
Get-AzVirtualNetwork -ResourceGroupName $vm.ResourceGroupName | Remove-AzVirtualNetwork -Force

#Delete the network security group:
Get-AzNetworkSecurityGroup -ResourceGroupName $vm.ResourceGroupName | Remove-AzNetworkSecurityGroup -Force

#And finally, delete the public IP address:
Get-AzPublicIpAddress -ResourceGroupName $vm.ResourceGroupName | Remove-AzPublicIpAddress -Force

#CREATING A SCRIPT
param([string]$resourceGroup)

$adminCredential = Get-Credential -Message "Enter a username and password for the VM administrator."

For ($i = 1; $i -le 3; $i++)
{
    $vmName = "ConferenceDemo" + $i
    Write-Host "Creating VM: " $vmName
    New-AzVm -ResourceGroupName $resourceGroup -Name $vmName -Credential $adminCredential -Image Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest
}

./ConferenceDailyReset.ps1 learn-dc059acd-c63c-4aa7-ac70-0b7376e9f04c
#this gets vms
Get-AzResource -ResourceType Microsoft.Compute/virtualMachines

#remove resouce groups
Remove-AzResourceGroup -Name MyResourceGroupName

#Restarting a vm with CLI

az vm restart -g MyResourceGroup -n MyVm

#Installing az-cli on Mac
brew update
brew install azure-cli

#Installing az-cli in Linux Ubuntu
#   Modify your sources list so that the Microsoft repository is registered and the package manager can locate the Azure CLI package:
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | \
sudo tee /etc/apt/sources.list.d/azure-cli.list

curl https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -

sudo apt-get install apt-transport-https
sudo apt-get update && sudo apt-get install azure-cli

#Installing az-cli on Windows
# go to https://aka.ms/installazurecliwindows
# it will download azure-cli-2.50.0.msi install it as you normally would.

## Work with the Azure CLI

#eg find the most popular commands related to the word blob.
az find blob

#Example: Show me the most popular commands for an Azure CLI command group, such as az vm.
az find "az vm"

#Example: Show me the most popular parameters and subcommands for an Azure CLI command.
az find "az vm create"

#--help will get you more detailed information on a command
#example, here's how you can get a list of the subgroups and commands for managing blob storage:
az storage blob --help

##              How to create an Azure resource
#When you're creating a new Azure resource, there are typically three steps: 
#   connect to your Azure subscription, create the resource, and verify that creation was successful.
#Each step corresponds to a different Azure CLI command.
#           Connect
#Azure CLI login command
az login

#           Create
#The Azure CLI group create command creates a resource group. 
#The core syntax is:
#   az group create --name <name> --location <location>
az group create --name MyCliCreatedResouceGroup --location "Australia East" 

#           Verify
#For example, the Azure CLI group list command lists your Azure resource groups. 
az group list 
az group list --output table 

#               Exercise - Create an Azure website using the CLI
<#
Select a region from this list when you create resources:
westus2
southcentralus
centralus
eastus
westeurope
southeastasia
japaneast
brazilsouth
australiasoutheast
centralindia
#>
#Your first step in this exercise is to create several variables to use in later commands.
export RESOURCE_GROUP=learn-45035e9c-5a06-49d1-96b0-0f56bce58b51
export AZURE_REGION=eastus
export AZURE_APP_PLAN=popupappplan-$RANDOM
export AZURE_WEB_APP=popupwebapp-$RANDOM

#If you have several items in the group list, you can filter the return values by adding a --query option. 
az group list --query "[?name == '$RESOURCE_GROUP']"

#   Steps to create a service plan
#Create an App Service plan to run your app. The following command specifies the free pricing tier, 
#   but you can run az appservice plan create --help to see the other pricing tiers.

az appservice plan create --name $AZURE_APP_PLAN --resource-group $RESOURCE_GROUP --location $AZURE_REGION --sku FREE

# test 
az appservice plan list --output table

#   Steps to create a web app
az webapp create --name $AZURE_WEB_APP --resource-group $RESOURCE_GROUP --plan $AZURE_APP_PLAN
az webapp list --output table

#Make a note of the default hostname popupwebapp-18343.azurewebsites.net

curl $AZURE_WEB_APP.azurewebsites.net

#   Steps to deploy code from GitHub
<#
The final step is to deploy code from a GitHub repository to the web app. Let's use a basic PHP page available in the 
Azure Samples GitHub repository that displays "Hello World!" when it executes. Make sure to use the web app name you created.
#>

az webapp deployment source config --name $AZURE_WEB_APP --resource-group $RESOURCE_GROUP --repo-url "https://github.com/Azure-Samples/php-docs-hello-world" --branch master --manual-integration

#Once it's deployed, hit your site again with a browser or CURL.
curl $AZURE_WEB_APP.azurewebsites.net

#               Deploy an ARM template to Azure===============
#First, sign in to Azure by using the Azure CLI or Azure PowerShell.
az login
Connect-AzAccount
<#
Next, define your resource group. You can use an already-defined resource group or create a new one with the following command. 
You can obtain available location values from: az account list-locations (CLI) or Get-AzLocation (PowerShell). 
You can configure the default location using az configure --defaults location=<location>.
#>
az account list-locations
Get-azlocation
(Get-AzLocation | Where-Object {$_.location -like "aust*"}).Location
#   New-AzResourceGroup -Name {name of your resource group}   -Location "{location}"
<#
az group create \
  --name {name of your resource group} \
  --location "{location}"
#>

#To start a template deployment at the resource group, use either the Azure CLI command az deployment group create 
#or the Azure PowerShell command New-AzResourceGroupDeployment.

<#
templateFile="{provide-the-path-to-the-template-file}"
az deployment group create \
  --name blanktemplate \
  --resource-group myResourceGroup \
  --template-file $templateFile
#>
<#
$templateFile = "{provide-the-path-to-the-template-file}"
New-AzResourceGroupDeployment `
  -Name blanktemplate `
  -ResourceGroupName myResourceGroup `
  -TemplateFile $templateFile
#>
$context = Get-AzSubscription -SubscriptionId aeff3ba4-dcf3-47c3-88a4-a647ce19dxxx
Set-AzContext $context
New-AzResourceGroup -Name MyRGForTemplatePlay -Location australiasoutheast
$templateFile="azuredeploy.json"
$today=Get-Date -Format "MM-dd-yyyy"
$deploymentName="blanktemplate-"+"$today"
New-AzResourceGroupDeployment -Name $deploymentName -TemplateFile $templateFile -ResourceGroupName MyRGForTemplatePlay

Set-AzDefault -ResourceGroupName MyRGForTemplatePlay

#     Deploy the updated ARM template
$templateFile="azuredeploy.json"
$today=Get-Date -Format "MM-dd-yyyy"
$deploymentName="addstorage-"+"$today"
New-AzResourceGroupDeployment `
  -Name $deploymentName `
  -TemplateFile $templateFile

#     Use parameters in an ARM template
<#
"parameters": {
  "storageAccountType": {
    "type": "string",
    "defaultValue": "Standard_LRS",
    "allowedValues": [
      "Standard_LRS",
      "Standard_GRS",
      "Standard_ZRS",
      "Premium_LRS"
    ],
    "metadata": {
      "description": "Storage Account type"
    }
  }
}
#>
<#
"resources": [
  {
    "type": "Microsoft.Storage/storageAccounts",
    "apiVersion": "2019-04-01",
    "name": "learntemplatestorage123",
    "location": "[resourceGroup().location]",
    "sku": {
      "name": "[parameters('storageAccountType')]"
    },
    "kind": "StorageV2",
    "properties": {
      "supportsHttpsTrafficOnly": true
    }
  }
]
#>

#When you deploy the template, you can give a value for the parameter. Notice the last line in the following command:

<#
templateFile="azuredeploy.json"
az deployment group create \
  --name testdeployment1 \
  --template-file $templateFile \
  --parameters storageAccountType=Standard_LRS
#>

$templateFile="azuredeploy.json"
New-AzResourceGroupDeployment `
  -Name testdeployment1 `
  -TemplateFile $templateFile `
  -storageAccountType Standard_LRS

 <#
 ARM template outputs
In the outputs section of your ARM template, you can specify values that will be returned after a successful deployment. 
Here are the elements that make up the outputs section.
#> 

<#
"outputs": {
  "<output-name>": {
    "condition": "<boolean-value-whether-to-output-value>",
    "type": "<type-of-output-value>",
    "value": "<output-value-expression>",
    "copy": {
      "count": <number-of-iterations>,
      "input": <values-for-the-variable>
    }
  }
}
#>

<#
Here's an example to output the storage account's endpoints.

JSON

"outputs": {
  "storageEndpoint": {
    "type": "object",
    "value": "[reference('learntemplatestorage123').primaryEndpoints]"
  }
}
#>

#         Exercise - Add parameters and outputs to your Azure Resource Manager template

#     Deploy the parameterized ARM template
$templateFile="azuredeploy.json"
$today=Get-Date -Format "MM-dd-yyyy"
$deploymentName="addnameparameter-"+"$today"
New-AzResourceGroupDeployment -Name $deploymentName -TemplateFile $templateFile -storageName "paulsarmtempleddstonname"

$today=Get-Date -Format "MM-dd-yyyy"
$deploymentName="addSkuParameter-"+"$today"
New-AzResourceGroupDeployment `
  -Name $deploymentName `
  -TemplateFile $templateFile `
  -storageName "paulsarmtempleddstonname" `
  -storageSKU Standard_GRS


#     Add output to the ARM template
$today=Get-Date -Format "MM-dd-yyyy"
$deploymentName="addOutputs-"+"$today"
New-AzResourceGroupDeployment `
  -Name $deploymentName `
  -TemplateFile $templateFile `
  -storageName "paulsarmtempleddstonname" `
  -storageSKU Standard_LRS

  New-AzRoleDefinition -InputFile $HOME/az104-03d-CustomRoleDefinition.json 

  ###############Crete users and groups in az###########
# create a new user cli
az ad user create

# create a new user PS
New-AzureADUser

#You can bulk create member users and guests accounts. 
# The following example shows how to bulk invite guest users.
$invitations = import-csv c:\bulkinvite\invitations.csv

$messageInfo = New-Object Microsoft.Open.MSGraph.Model.InvitedUserMessageInfo

$messageInfo.customizedMessageBody = "Hello. You are invited to the Contoso organization."

foreach ($email in $invitations){
  New-AzureADMSInvitation `
    -InvitedUserEmailAddress $email.InvitedUserEmailAddress `
    -InvitedUserDisplayName $email.Name `
    -InviteRedirectUrl https://myapps.microsoft.com `
    -InvitedUserMessageInfo $messageInfo `
    -SendInvitationMessage $true
}

# Delete user accounts
#In PowerShell, run the cmdlet Remove-AzADUser. 
#In the Azure CLI, run the cmdlet az ad user delete.

