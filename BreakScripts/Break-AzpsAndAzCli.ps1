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

#You can also create a blob container with PowerShell by using the New-AzStorageContainer command.
<#
export STORAGENAME=medicalrecords$RANDOM

az storage account create \
    --name $STORAGENAME \
    --access-tier hot \
    --kind StorageV2 \
    --resource-group learn-40d6d915-28e1-4e3c-99ad-6769a841b765

#>



<#
Create a container under the storage account for storing the images.


az storage container create \
    --name patient-images \
    --account-name $STORAGENAME \
    --public-access off


Clone your team's existing web app. This repository contains example images used by your team for testing.
git clone https://github.com/MicrosoftDocs/mslearn-control-access-to-azure-storage-with-sas.git sas
#>
<#
Use the Azure CLI upload-batch command to upload the images into your storage account.

az storage blob upload-batch \
    --source sas \
    --destination patient-images \
    --account-name $STORAGENAME \
    --pattern *.jpg
#>

##################Create a storage account and add a blob

az storage account create `
--name  mslearn$RANDOM `
--resource-group learn-80dc492b-3934-440f-ad11-84686b287851 `
--sku Standard_GRS `
--kind StorageV2

########Create a storage account with Azure Data Lake Storage Gen2 capabilities
# az storage account create `
#     --name dlstoragetest$RANDOM `
#     --resource-group learn-80dc492b-3934-440f-ad11-84686b287851 `
#     --location westus2 `
#     --sku Standard_LRS `
#     --kind StorageV2 `
#     --hns

####Create the CoreServicesVnet virtual network
<#
az network vnet create \
    --resource-group learn-cf33377c-d7ef-420d-a9ab-344b548047da \
    --name CoreServicesVnet \
    --address-prefixes 10.20.0.0/16 \
    --location westus

Now, let's create the subnets that we need for the planned resources in the virtual network:

Azure CLI

Copy
az network vnet subnet create \
    --resource-group learn-cf33377c-d7ef-420d-a9ab-344b548047da \
    --vnet-name CoreServicesVnet \
    --name GatewaySubnet \
    --address-prefixes 10.20.0.0/27

az network vnet subnet create \
    --resource-group learn-cf33377c-d7ef-420d-a9ab-344b548047da \
    --vnet-name CoreServicesVnet \
    --name SharedServicesSubnet \
    --address-prefixes 10.20.10.0/24

az network vnet subnet create \
    --resource-group learn-cf33377c-d7ef-420d-a9ab-344b548047da \
    --vnet-name CoreServicesVnet \
    --name DatabaseSubnet \
    --address-prefixes 10.20.20.0/24

az network vnet subnet create \
    --resource-group learn-cf33377c-d7ef-420d-a9ab-344b548047da \
    --vnet-name CoreServicesVnet \
    --name PublicWebServiceSubnet \
    --address-prefixes 10.20.30.0/24
Let's take a look at what we've created. Run this command to show all the subnets that we configured:

Azure CLI

Copy
az network vnet subnet list \
    --resource-group learn-cf33377c-d7ef-420d-a9ab-344b548047da \
    --vnet-name CoreServicesVnet \
    --output table
You should see the following subnets listed:

Output

Copy
AddressPrefix    Name                    PrivateEndpointNetworkPolicies    PrivateLinkServiceNetworkPolicies    ProvisioningState    ResourceGroup
---------------  ----------------------  --------------------------------  -----------------------------------  -------------------  -------------------------------------------
10.20.0.0/27     GatewaySubnet           Enabled                           Enabled                              Succeeded            learn-cf33377c-d7ef-420d-a9ab-344b548047da
10.20.10.0/24    SharedServicesSubnet    Enabled                           Enabled                              Succeeded            learn-cf33377c-d7ef-420d-a9ab-344b548047da
10.20.20.0/24    DatabaseSubnet          Enabled                           Enabled                              Succeeded            learn-cf33377c-d7ef-420d-a9ab-344b548047da
10.20.30.0/24    PublicWebServiceSubnet  Enabled                           Enabled                              Succeeded            learn-cf33377c-d7ef-420d-a9ab-344b548047da
#>

<# creating vnet with a subnet.
az network vnet create \
    --resource-group learn-65304589-58f1-47fe-8781-e109d60d4900 \
    --name SalesVNet \
    --address-prefixes 10.1.0.0/16 \
    --subnet-name Apps \
    --subnet-prefixes 10.1.1.0/24 \
    --location northeurope

az network vnet list --query "[?contains(provisioningState, 'Succeeded')]" --output table

#>

###Create virtual machines in each virtual network
<#
az vm create \
    --resource-group learn-65304589-58f1-47fe-8781-e109d60d4900 \
    --no-wait \
    --name SalesVM \
    --location northeurope \
    --vnet-name SalesVNet \
    --subnet Apps \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password <password>



watch -d -n 5 "az vm list \
    --resource-group learn-65304589-58f1-47fe-8781-e109d60d4900 \
    --show-details \
    --query '[*].{Name:name, ProvisioningState:provisioningState, PowerState:powerState}' \
    --output table"


#>

###Create virtual network peering connections

<#
az network vnet peering create \
    --name SalesVNet-To-MarketingVNet \
    --remote-vnet MarketingVNet \
    --resource-group learn-65304589-58f1-47fe-8781-e109d60d4900 \
    --vnet-name SalesVNet \
    --allow-vnet-access

###Run the following command to create a reciprocal connection from MarketingVNet to SalesVNet. This step completes the connection between these virtual networks.


az network vnet peering create \
    --name MarketingVNet-To-SalesVNet \
    --remote-vnet SalesVNet \
    --resource-group learn-65304589-58f1-47fe-8781-e109d60d4900 \
    --vnet-name MarketingVNet \
    --allow-vnet-access
#>
### Check the virtual network peering connections
<#
az network vnet peering list \
    --resource-group learn-65304589-58f1-47fe-8781-e109d60d4900 \
    --vnet-name SalesVNet \
    --query "[].{Name:name, Resource:resourceGroup, PeeringState:peeringState, AllowVnetAccess:allowVirtualNetworkAccess}"\
    --output table


#>

### Check effective routes
#Run the following command to look at the routes that apply to the SalesVM network interface
<#
az network nic show-effective-route-table \
    --resource-group learn-65304589-58f1-47fe-8781-e109d60d4900 \
    --name SalesVMVMNic \
    --output table
#>

<# querys the vms for name private and public ips
az vm list \
    --resource-group learn-65304589-58f1-47fe-8781-e109d60d4900 \
    --query "[*].{Name:name, PrivateIP:privateIps, PublicIP:publicIps}" \
    --show-details \
    --output table


Name         PrivateIP    PublicIP
-----------  -----------  --------------
MarketingVM  10.2.1.4     4.245.199.73
SalesVM      10.1.1.4     4.245.198.228
ResearchVM   10.3.1.4     20.160.124.226
#>

###Create a route table and custom route

#Create a route table
<#
az network route-table create \
        --name publictable \
        --resource-group learn-0ac4a860-66e2-4348-8826-58b029956dd0 \
        --disable-bgp-route-propagation false
#>

# Create a custon route
<#
az network route-table route create \
        --route-table-name publictable \
        --resource-group learn-0ac4a860-66e2-4348-8826-58b029956dd0 \
        --name productionsubnet \
        --address-prefix 10.0.1.0/24 \
        --next-hop-type VirtualAppliance \
        --next-hop-ip-address 10.0.2.4
#>

# associate route table with public subnet.
<#
az network vnet subnet update \
        --name publicsubnet \
        --vnet-name vnet \
        --resource-group learn-0ac4a860-66e2-4348-8826-58b029956dd0 \
        --route-table publictable
#>

#create a new public IP address
$Location = $(Get-AzureRmResourceGroup -ResourceGroupName learn-dd3518c2-d217-4e21-8b38-7738b09a673b).Location

$publicIP = New-AzPublicIpAddress `
  -ResourceGroupName learn-dd3518c2-d217-4e21-8b38-7738b09a673b `
  -Location $Location `
  -AllocationMethod "Static" `
  -Name "myPublicIP"

#Create a front-end IP by using the New-AzLoadBalancerFrontendIpConfig cmdlet
$frontendIP = New-AzLoadBalancerFrontendIpConfig -Name "myFrontEnd" -PublicIpAddress $publicIP

#When you use PowerShell to configure a load balancer, you must create the back-end address pool, the health probe, and the rule before you create the balancer itself.
#Create a back-end address pool by running the New-AzLoadBalancerBackendAddressPoolConfig cmdlet.
$backendPool = New-AzLoadBalancerBackendAddressPoolConfig -Name "myBackEndPool"

#To allow the load balancer to monitor the status of the healthcare portal, create a health probe. The health probe dynamically adds or removes VMs from the load balancer rotation based on their response to health checks.
$probe = New-AzLoadBalancerProbeConfig -Name "myHealthProbe" -Protocol http -Port 80 -IntervalInSeconds 5 -ProbeCount 2 -RequestPath "/"

#You now need a load balancer rule that's used to define how traffic is distributed to the VMs. You define the front-end IP configuration for the incoming traffic and the back-end IP pool to receive the traffic, along with the required source and destination port. To make sure only healthy VMs receive traffic, you also define the health probe to use.
$lbrule = New-AzLoadBalancerRuleConfig -Name "myLoadBalancerRule" -FrontendIpConfiguration $frontendIP -BackendAddressPool $backendPool -Protocol Tcp -FrontendPort 80 -BackendPort 80 `
  -Probe $probe

#Now, you can create the basic load balancer by running the New-AzLoadBalancer cmdlet.
$lb = New-AzLoadBalancer `
  -ResourceGroupName learn-dd3518c2-d217-4e21-8b38-7738b09a673b `
  -Name 'MyLoadBalancer' `
  -Location $Location `
  -FrontendIpConfiguration $frontendIP `
  -BackendAddressPool $backendPool `
  -Probe $probe `
  -LoadBalancingRule $lbrule

  #Connect the VMs to the back-end pool by updating the network interfaces that the script created to use the back-end pool information.
$nic1 = Get-AzNetworkInterface -ResourceGroupName learn-dd3518c2-d217-4e21-8b38-7738b09a673b -Name "webNic1"
$nic2 = Get-AzNetworkInterface -ResourceGroupName learn-dd3518c2-d217-4e21-8b38-7738b09a673b -Name "webNic2"

$nic1.IpConfigurations[0].LoadBalancerBackendAddressPools = $backendPool
$nic2.IpConfigurations[0].LoadBalancerBackendAddressPools = $backendPool

Set-AzNetworkInterface -NetworkInterface $nic1 -AsJob
Set-AzNetworkInterface -NetworkInterface $nic2 -AsJob

#Run the following command to get the public IP address of the load balancer and the URL for your website.
Write-Host http://$($(Get-AzPublicIPAddress -ResourceGroupName learn-dd3518c2-d217-4e21-8b38-7738b09a673b -Name "myPublicIP").IpAddress)


# Register resource provider
Register-AzResouceProvider -ProviderNamespace Microsoft.Insights

#You can also use the PowerShell Set-AzVmCustomScriptExtension command to run scripts with Custom Script Extensions. This command requires the URI for the script in the blob container.
Set-AzVmCustomScriptExtension -FileUri https://scriptstore.blob.core.windows.net/scripts/Install_IIS.ps1 -Run "PowerShell.exe" -VmName vmName `
 -ResourceGroupName resourceGroup -Location "location"

 ###Create a Linux VM with the Azure CLI
 <#
 az vm create \
  --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432 \
  --location westus \
  --name SampleVM \
  --image UbuntuLTS \
  --admin-username azureuser \
  --generate-ssh-keys \
  --verbose
 #>
 #Listing images
 az vm image list --output table
 #Getting all images --all flag
 # eg try the following command to see all Wordpress images available:
 az vm image list --sku Wordpress --output table --all
 <#
 Or this command to see all images provided by Microsoft:


az vm image list --publisher Microsoft --output table --all
 #>

 <#
 Some images are only available in certain locations. Try adding the --location [location] flag to the 
 command to scope the results to ones available in the region where you want to create the virtual machine. 
 For example, type the following into Azure Cloud Shell to get a list of images available in the eastus region.


az vm image list --location eastus --output table
 #>

<#
The available sizes change based on the region in which you're creating the VM. You can get a list of the available sizes using the vm list-sizes command. Try typing the following into Azure Cloud Shell:
#>

az vm list-sizes --location eastus --output table

<#
Specify a size during VM creation
We didn't specify a size when we created our VM, so Azure selected a default general-purpose size for us. However, 
we can specify the size as part of the vm create command using the --size parameter. For example, 
you could use the following command to create a 2-core virtual machine:


az vm create \
    --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432 \
    --name SampleVM2 \
    --image UbuntuLTS \
    --admin-username azureuser \
    --generate-ssh-keys \
    --verbose \
    --size "Standard_DS2_v2"
#>

<#
Resize an existing VM
We can also resize an existing VM if the workload changes or if it was incorrectly sized at creation. 
Let's use the first VM we created, SampleVM. Before requesting a resize, we must check to see if the desired size is available in the cluster our VM is part of. 
We can do this with the vm list-vm-resize-options command:


az vm list-vm-resize-options \
    --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432 \
    --name SampleVM \
    --output table
#>

<#
To resize a VM, we use the vm resize command. For example, perhaps we find our VM is underpowered for the task we want it to perform. 
We could bump it up to a D2s_v3, where it has 2 vCores and 8 GB of memory. 
Type this command in Cloud Shell:


az vm resize \
    --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432 \
    --name SampleVM \
    --size Standard_D2s_v3
This command will take a few minutes to reduce the resources of the VM, and once it's done, it will return a new JSON configuration.


#>

#                   Exercise - Query system and runtime information about the VM

<#
Now that a virtual machine has been created, we can get information about it through other commands.

Let's start by running vm list.


az vm list
#>

<#
Get the IP address
Another useful command is vm list-ip-addresses, which will list the public and private IP addresses for a VM. If they change, or you didn't capture them during creation, you can retrieve them at any time.

Azure CLI

Copy
az vm list-ip-addresses -n SampleVM -o table
This returns output like:


Copy
VirtualMachine    PublicIPAddresses    PrivateIPAddresses
----------------  -------------------  --------------------
SampleVM          168.61.54.62         10.0.0.4
#>

<#
Get VM details
We can get more detailed information about a specific virtual machine by name or ID running the vm show command.


az vm show --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432 --name SampleVM
#>

<#
Filter your Azure CLI queries
With a basic understanding of JMES queries, we can add filters to the data being returned by queries like the vm show command. For example, we can retrieve the admin username:

Azure CLI

Copy
az vm show \
    --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432 \
    --name SampleVM \
    --query "osProfile.adminUsername"
We can get the size assigned to our VM:

Azure CLI

Copy
az vm show \
    --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432 \
    --name SampleVM \
    --query hardwareProfile.vmSize
Or, to retrieve all the IDs for your network interfaces, you can run the query:

Azure CLI

Copy
az vm show \
    --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432 \
    --name SampleVM \
    --query "networkProfile.networkInterfaces[].id"
#>

#       Exercise - Start and stop your VM with the Azure CLI

<#
Stop a VM
We can stop a running VM with the vm stop command. You must pass the name and resource group, or the unique ID for the VM:

Azure CLI

Copy
az vm stop \
    --name SampleVM \
    --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432
We can verify the VM has stopped by attempting to ping the public IP address, using ssh, or through the vm get-instance-view command. This final approach returns the same basic data as vm show, but includes details about the instance itself. Try entering the following command into Azure Cloud Shell to see the current running state of your VM:

Azure CLI

Copy
az vm get-instance-view \
    --name SampleVM \
    --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432 \
    --query "instanceView.statuses[?starts_with(code, 'PowerState/')].displayStatus" -o tsv
This command should return VM stopped as the result.

Start a VM
We can do the reverse through the vm start command.

Azure CLI

Copy
az vm start \
    --name SampleVM \
    --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432
This command will start a stopped VM. We can verify it through the vm get-instance-view query we used in the last section, which should now return VM running.

Restart a VM
Finally, we can restart a VM if we have made changes that require a reboot running the vm restart command. You can add the --no-wait flag if you want the Azure CLI to return immediately without waiting for the VM to reboot.
#>

#           Exercise - Install software on your VM
<#
Install NGINX web server
Locate the public IP address of your SampleVM Linux virtual machine.

Azure CLI

Copy
az vm list-ip-addresses --name SampleVM --output table
Next, open an ssh connection to SampleVM.

Bash

Copy
ssh azureuser@<PublicIPAddress>
After you're logged in to the virtual machine, run the following command to install the nginx web server. The command will take a few moments to complete.

Bash

Copy
sudo apt-get -y update && sudo apt-get -y install nginx
Exit the Secure Shell.

Bash

Copy
exit
Retrieve your default page
In Azure Cloud Shell, use curl to read the default page from your Linux web server by running the following command, replacing <PublicIPAddress> with the public IP you found previously. You can also open a new browser tab and try to browse to the public IP address.

Bash

Copy
curl -m 80 <PublicIPAddress>
This command will fail, because the Linux virtual machine doesn't expose port 80 (http) through the network security group that secures the network connectivity to the virtual machine. We can fix the failure by running the Azure CLI command vm open-port.

Enter the following command into Cloud Shell to open port 80:

Azure CLI

Copy
az vm open-port \
    --port 80 \
    --resource-group learn-287d5f2c-b2c1-4586-af8b-464372600432 \
    --name SampleVM
It will take a moment to add the network rule and open the port through the firewall.

Run the curl command again.

Bash

Copy
curl -m 80 <PublicIPAddress>
This time it should return data like the following. You can see the page in a browser as well.

HTML

Copy
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
body {
    width: 35em;
    margin: 0 auto;
    font-family: Tahoma, Verdana, Arial, sans-serif;
}
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support, refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
#>

#dsc snippet
<#
Configuration Create_Share
{
   Import-DscResource -Module xSmbShare
   # A node describes the VM to be configured

   Node $NodeName
   {
      # A node definition contains one or more resource blocks
      # A resource block describes the resource to be configured on the node
      xSmbShare MySMBShare
      {
          Ensure      = "Present"
          Name        = "MyFileShare"
          Path        = "C:\Shared"
          ReadAccess  = "User1"
          FullAccess  = "User2"
          Description = "This is an updated description for this share"
      }
   }
}
#>
<#
Configuration MyDscConfiguration {              ##1
  Node "localhost" {                          ##2
      WindowsFeature MyFeatureInstance {      ##3
          Ensure = 'Present'
          Name = 'Web-Server'
      }
  }
}
MyDscConfiguration -OutputPath C:\temp\         ##4
#>

#Node @('WEBSERVER1', 'WEBSERVER2', 'WEBSERVER3')
#this is a node block if you want to include the names of more than one server.


