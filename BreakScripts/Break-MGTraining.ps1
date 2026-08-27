break;
# to miniminise block control k and control 0 
get-module -Name microsoft.graph -ListAvailable

Update-Module Microsoft.Graph

Find-MgGraphCommand -command Get-MgUser | Select-Object -First 1 -ExpandProperty Permissions

#region USE POWERSHELL https://learn.microsoft.com/en-us/powershell/microsoftgraph/get-started?view=graph-powershell-1.0

# Sign in
Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"

#       Call Microsoft Graph

# Get a user
get-mguser

$user = Get-MgUser -Filter "userPrincipalName eq 'MeganB@contoso.onmicrosoft.com'"

$user = Get-MgUser -Filter "userPrincipalName eq ''"

$user.DisplayName

# List the user's joined teams
Get-MgUserJoinedTeam -UserId $user.Id

$team = Get-MgTeam -TeamId '167ee499-b155-4d06-ae16-f8289350ad31'

# List team channels
Get-MgTeamChannel -TeamId $team.Id
$channel = Get-MgTeamChannel -TeamId $team.id -Filter "displayName eq 'General'"

# Send a message
New-MgTeamChannelMessage -TeamId $team.Id -ChannelId $channel.Id -Body @{ Content="Hello World" }


New-MgTeamChannelMessage -TeamId $team.Id -ChannelId $channel.Id -Body @{ Content="Hello World" } -Importance "urgent"

#Sign out
Disconnect-MgGraph

#endregion

#region Navigate the SDK https://learn.microsoft.com/en-us/powershell/microsoftgraph/navigating?view=graph-powershell-1.0

# Command naming conventions

# Command verbs

<#
HTTP Method	            Command Verb	     Example
GET	                    Get	                 Get-MgUser 
POST	                New	                 New-MgUser 
PUT	                    New	                 New-MgTeam 
PATCH	                Update	             Update-MgUser 
DELETE	                Remove	             Remove-MgUser 
#>

# Command nouns
#   nouns start with Mg

# Listing parameters
Get-Help Get-MgUser -Detailed

# Finding available commands
<#
Sometimes just knowing the naming conventions isn't enough to guess the right command. In this case, 
you can use the Get-Command command to search the available commands in Microsoft Graph PowerShell. 
For example, if you're looking for commands related to Microsoft Teams, you can run the following command.
#>

Get-Command -Module Microsoft.Graph* *team*
Get-Command -Module Microsoft.Graph* -verb get -Noun *team* 

Get-Help Find-MgGraphCommand -Examples

Find-MgGraphCommand -Uri "/users/{id}"

#endregion

###Authentication module cmdlets in Microsoft Graph PowerShell

#region use Authentication Cmdlets https://learn.microsoft.com/en-us/powershell/microsoftgraph/authentication-commands?view=graph-powershell-1.0

# Use Connect-MgGraph

#There are three ways to allow delegated access using Connect-MgGraph:

#Use interactive authentication, where you specify the permissions (scopes) needed for your session:


Connect-MgGraph -Scopes "User.Read.All", "Group.ReadWrite.All"

#Use device code flow:


Connect-MgGraph -Scopes "User.Read.All", "Group.ReadWrite.All" -UseDeviceAuthentication

#Use your own access token:

Connect-MgGraph -AccessToken $AccessToken
# Use delegated access with a custom application for Microsoft Graph PowerShell
<#
Complete the following steps to create a custom application that you can use to connect to Microsoft Graph PowerShell. Use this approach if you need to isolate and limit the consent permissions granted for Microsoft Graph PowerShell usage.

Go to the Microsoft Entra admin center - App registrations > New Registration.
Enter a Name for your application, for example Microsoft Graph PowerShell - High Privilege admin use only.
For Supported account types, select Accounts in this organization directory.
For Redirect URI:
Select Public client/native from the drop down
URI value: http://localhost
Select Register.
Go to Enterprise applications and select the application you just created.
Under Manage, select Properties and set Assignment required? to Yes.
Select Save.
Under Manage, select Users and groups.
Select Add user/group and add the users and groups permitted to use this application.
Once you've added all the users and groups, select Assign.
You can now use this app instead of the default Microsoft Graph PowerShell app registration by connecting with:
#>

Connect-MgGraph -ClientId '<YOUR_NEW_APP_ID>' -TenantId '<YOUR_TENANT_ID>'

## App-only access

# Use client credential with a certificate
<#
To use app-only access, you can load the certificate from either Cert:\CurrentUser\My\ or 
Cert:\LocalMachine\My\ when you specify the -CertificateThumbprint or -CertificateName parameters with Connect-MgGraph. 
Ensure the certificate you're using is present in either certificate store before calling Connect-MgGraph. 
#>
#Use Certificate Thumbprint:
Connect-MgGraph -ClientId "YOUR_APP_ID" -TenantId "YOUR_TENANT_ID" -CertificateThumbprint "YOUR_CERT_THUMBPRINT"

#Use Certificate name:
Connect-MgGraph -ClientId "YOUR_APP_ID" -TenantId "YOUR_TENANT_ID" -CertificateName "YOUR_CERT_SUBJECT"

#Use Certificate
$Cert = Get-ChildItem Cert:\LocalMachine\My\$CertThumbprint
Connect-MgGraph -ClientId "YOUR_APP_ID" -TenantId "YOUR_TENANT_ID" -Certificate $Cert
#To use a certificate stored in your machine's certificate store or another location when connecting to Microsoft Graph, specify the certificate's location.

#  Use client secret credentials
<#This type of grant helps when you need interactions in the background without a user to sign in. 
You can use the -ClientSecretCredential parameter with Connect-MgGraph to provide client secret credentials. 
See Get-Credential on how to get or create credentials.
#>
# Define the Application (Client) ID and Secret
$ApplicationClientId = '<application(client)ID>'
$ApplicationClientSecret = '<secret.value>' # Application Secret Value
$TenantId = 'Tenant_Id'

# Convert the Client Secret to a Secure String
$SecureClientSecret = ConvertTo-SecureString -String $ApplicationClientSecret -AsPlainText -Force

# Create a PSCredential Object Using the Client ID and Secure Client Secret
$ClientSecretCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $ApplicationClientId, $SecureClientSecret
# Connect to Microsoft Graph Using the Tenant ID and Client Secret Credential
Connect-MgGraph -TenantId $TenantId -ClientSecretCredential $ClientSecretCredential

#Use Managed Identity
<#
A common challenge when writing automation scripts is managing secrets, credentials, certificates, and keys. 
These are used to secure communication between services. 
Eliminate the need to manage credentials by allowing the module to obtain access tokens for Microsoft Entra resources that are protected by Microsoft Entra ID. 
The identity is managed by the Microsoft Entra platform and does not require you to provision or rotate any secrets.

A common challenge when writing automation scripts is the management of secrets, credentials, certificates, and keys used to secure communication between services. 
Eliminate the need to manage credentials by allowing the module to obtain access tokens for Microsoft Entra resources that are protected by Microsoft Entra ID. 
The identity is managed by the Microsoft Entra platform and does not require you to provision or rotate any secrets.
#>

#System-assigned managed identity: Uses an automatically managed identity on a service instance. The identity is tied to the lifecycle of a service instance.
Connect-MgGraph -Identity

#User-assigned managed identity: Uses a user created managed identity as a standalone Microsoft Entra resource.
Connect-MgGraph -Identity -ClientId "<USER_ASSIGNED_MANAGED_IDENTITY_CLIENT_ID>"

# Connect to an environment as a different identity
<#
To connect as a different identity other than CurrentUser, 
specify the -ContextScope parameter with the value Process, 
which limits the authentication context to the current PowerShell session instead of persisting it for the user across all sessions.
#>
Connect-MgGraph -ContextScope Process


<#
Passwordless authentication is a method of verifying a user’s identity without the use of a password. Passwords are a primary attack vector and passwordless authentication is a strategy to mitigate attacks where bad actors use social engineering, phishing, and spray attacks to compromise passwords.

Microsoft Graph PowerShell supports the following passwordless authentication methods:

- Windows Hello for Business
- Fast Identity Online v2.0 (FIDO2)
- Microsoft Authenticator app
- Certificate-based authentication (CBA)
 
 Note The use of FIDO2 security keys for authentication is supported only in PowerShell 7 and above.
#>

# Use Disconnect-MgGraph
<#
Once you're signed in, you remain signed in until you invoke Disconnect-MgGraph. Microsoft Graph PowerShell automatically refreshes the access token for you, and sign-in persists across PowerShell sessions because Microsoft Graph PowerShell securely caches the token when using the default CurrentUser context scope. If you use the -ContextScope Process parameter with Connect-MgGraph, sign-in only persists for the current PowerShell session.

Use Disconnect-MgGraph to sign out.
#>

Disconnect-MgGraph

# Use Get-MgEnvironment
<#When you use Connect-MgGraph, you can choose to target other environments. By default, Connect-MgGraph targets the global public cloud.

To get a list of all clouds that you can choose from, run:
#>

Get-MgEnvironment

<#
To explicitly target other clouds, for example, US Government and Azure China, use the -Environment parameter, 
which accepts values shown in the previous output (such as Global, China, USGov, and USGovDoD).
#>

Connect-MgGraph -Environment USGov

# Use Get-MgContext
<#
Get-MgContext is used to retrieve the details about your current session, which include:

ClientID
TenantID
Certificate Thumbprint
Scopes consented to
AuthType: Delegated or app-only
AuthProviderType
CertificateName
Account
AppName
ContextScope
Certificate
PSHostVersion
ClientTimeout
#>
#To retrieve the session details, run:

Get-MgContext

#To retrieve all the scopes that you've consented to, use Select-Object with the -ExpandProperty parameter to expand the Scopes property: Each scope is output on a new line when using -ExpandProperty.

Get-MgContext | Select-Object -ExpandProperty Scopes

#  Use Invoke-MgGraphRequest

<#
Invoke-MgGraphRequest issues REST API requests to Microsoft Graph and supports all HTTP methods (GET, POST, PATCH, DELETE, etc.), 
allowing you to both read and modify resources. 
It works for any Graph API if you know the REST URI, method, 
and optional body parameter, and is especially useful for accessing APIs for which there isn't an equivalent cmdlet yet.
#>

#To retrieve the details of the signed-in user, run:
Invoke-MgGraphRequest -Method GET -Uri https://graph.microsoft.com/v1.0/me



#endregion

#region Use Find-MgGraphCommand https://learn.microsoft.com/en-us/powershell/microsoftgraph/find-mg-graph-command?view=graph-powershell-1.0

<#
Find-MgGraphCommand helps you discover which API path a command calls by providing a URI or command name.

You can use the Find-MgGraphCommand cmdlet to:

Pass a Microsoft Graph URL (relative and absolute) and get an equivalent Microsoft Graph PowerShell command.
Pass a command and get the URL it calls.
Pass a command or URI wildcard, for example .*, to find all matching commands.
The output of this cmdlet also includes the permissions required to authenticate the specified cmdlet. 
For more information on discovering permissions, see Using Find-MgGraphPermission, which is a separate cmdlet dedicated to permissions discovery.

The permissions displayed don't indicate privilege levels. For guidance on choosing permissions, understanding permission types, 
and identifying the most or least privileged permissions, refer to the documentation for the corresponding API page.
#>

#  Find Microsoft Graph PowerShell commands by URI
# Find-MgGraphCommand -Uri <String[]> [-Method <String>] [-ApiVersion <String>] [<CommonParameters>]

Find-MgGraphCommand -Uri '/users/{id}'

#Note
<#
For the -ApiVersion parameter, there are two possible values: v1.0 and beta.
The -Method parameter is only available when using a URI to find commands and allows HTTP methods such as GET, POST, PUT, PATCH, and DELETE.
#>

# Find Microsoft Graph PowerShell commands by command name
# Syntax
# Find-MgGraphCommand -Command <String[]> [-ApiVersion <String>] [<CommonParameters>]

Find-MgGraphCommand -Command 'Get-MgUser'

# Pass a command and get the permissions required
Find-MgGraphCommand -command Get-MgUser | Select-Object -First 1 -ExpandProperty Permissions

# Find Microsoft Graph PowerShell commands using a command wildcard
#  Syntax # Find-MgGraphCommand -Command .*searchstring.* [-ApiVersion <String>] [<CommonParameters>]

#Example 1: Search for commands using a command wildcard
Find-MgGraphCommand -Command .*UserToDo.* -APIVersion 'v1.0'

# Find Microsoft Graph PowerShell commands using a URI wildcard
# Syntax # Find-MgGraphCommand -Uri .*searchstring.* [-ApiVersion <String>] [<CommonParameters>] [-Method <String>]
# Example
Find-MgGraphCommand -Uri ".*users.*" -Method 'Get' -ApiVersion 'v1.0'


#endregion

#region Use Find-MgGraphPermission https://learn.microsoft.com/en-us/powershell/microsoftgraph/find-mg-graph-permission?view=graph-powershell-1.0

# Use Find-MgGraphPermission

<#
The Microsoft Graph PowerShell SDK requires users to understand both the semantics and syntax of Microsoft Graph API permissions. The Find-MgGraphPermission cmdlet addresses the following questions:

How do I find the values to supply to the permission-related parameters of commands like New-MgApplication and other application and consent related commands?
What permissions are applicable to a certain domain? For example, application.
To use Microsoft Graph PowerShell to access Microsoft Graph, users must sign in to Microsoft Graph using the Connect-MgGraph cmdlet. Use the Find-MgGraphCommand to find which permissions to use for a specific cmdlet or API.

Currently, PowerShell commands and scripts can't validate user input that refers to permissions. They also don't provide an auto-complete experience to help users supply input accurately. This also affects commands or scripts implemented with the Microsoft Graph PowerShell SDK itself.

#>
# Find permissions related to a given domain
Find-MgGraphPermission application

# Find the identifier for a specific permission
Find-MgGraphPermission application.Read | Format-List

#endregion

#region Enable App-only Authentication https://learn.microsoft.com/en-us/powershell/microsoftgraph/app-only?view=graph-powershell-1.0

#Use app-only authentication with the Microsoft Graph PowerShell SDK

#The Microsoft Graph PowerShell SDK supports two types of authentication: delegated access, and app-only access. This guide will focus on the configuration needed to enable app-only access.

<#
Before you can use app-only access with the Microsoft Graph PowerShell SDK, make sure you have the required prerequisites:
The Microsoft Graph PowerShell SDK is installed. To install the SDK, follow the installation guide.
A certificate to use as a credential for the application. This certificate can be a self-signed certificate or a certificate from an authority. Refer to the See also section for guidance on how to create a self-signed certificate.
Have an X.509 certificate installed in your user's trusted store on the machine where you'll run the script.
Export the certificate's public key in .cer, .pem, or .crt format.
Get the value of the certificate subject or its thumbprint.
Register an application in Microsoft Entra ID, configure it with the permission scopes your scenario requires, and share the public key for your certificate.
#>

### Step 1 Register an application ###
<#
Step 1: Register an application
You can register an application using the Microsoft Graph PowerShell SDK with delegated access by signing in as an administrator, and creating the app registration. 
Follow these steps to register an application using the Microsoft Graph PowerShell SDK.
#>
# 1. Use a text editor to create a new file named RegisterAppOnly.ps1. Paste the following code into the file.
########################Cut here################################
param(
  [Parameter(Mandatory=$true, HelpMessage="The friendly name of the app registration")]
  [String]$AppName,

[Parameter(Mandatory=$true,
  HelpMessage="The file path to your public key file")]
  [String]$CertPath,

[Parameter(Mandatory=$false,
  HelpMessage="Your Azure Active Directory tenant ID")]
  [String]$TenantId,

[Parameter(Mandatory=$false)]
  [Switch]$StayConnected = $false
)

# Graph permissions constants
$graphResourceId = "00000003-0000-0000-c000-000000000000"
$UserReadAll = @{
  Id="df021288-bdef-4463-88db-98f22de89214"
  Type="Role"
}
$GroupReadAll = @{
  Id="5b567255-7703-4780-807c-7be8301ae99b"
  Type="Role"
}

# Requires an admin
if ($TenantId)
{
  Connect-MgGraph -Scopes "Application.ReadWrite.All User.Read" -TenantId $TenantId
}
else
{
  Connect-MgGraph -Scopes "Application.ReadWrite.All User.Read"
}

# Get context for access to tenant ID
$context = Get-MgContext

# Load cert
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2($CertPath)
Write-Host -ForegroundColor Cyan "Certificate loaded"

# Create app registration
$appRegistration = New-MgApplication -DisplayName $AppName -SignInAudience "AzureADMyOrg" -Web @{ RedirectUris="http://localhost"; } -RequiredResourceAccess @{ ResourceAppId=$graphResourceId; ResourceAccess=$UserReadAll, $GroupReadAll } -AdditionalProperties @{} -KeyCredentials @(@{ Type="AsymmetricX509Cert"; Usage="Verify"; Key=$cert.RawData })
Write-Host -ForegroundColor Cyan "App registration created with app ID" $appRegistration.AppId

# Create corresponding service principal
New-MgServicePrincipal -AppId $appRegistration.AppId -AdditionalProperties @{} | Out-Null
Write-Host -ForegroundColor Cyan "Service principal created"
Write-Host
Write-Host -ForegroundColor Green "Success"
Write-Host

# Generate admin consent URL
$adminConsentUrl = "https://login.microsoftonline.com/" + $context.TenantId + "/adminconsent?client_id=" + $appRegistration.AppId
Write-Host -ForeGroundColor Yellow "Please go to the following URL in your browser to provide admin consent"
Write-Host $adminConsentUrl
Write-Host

# Generate Connect-MgGraph command
$connectGraph = "Connect-MgGraph -ClientId """ + $appRegistration.AppId + """ -TenantId """ + $context.TenantId + """ -CertificateName """ + $cert.SubjectName.Name + """"
Write-Host -ForeGroundColor Cyan "After providing admin consent, you can use the following values with Connect-MgGraph for app-only:"
Write-Host $connectGraph

if ($StayConnected -eq $false)
{
  Disconnect-MgGraph
  Write-Host "Disconnected from Microsoft Graph"
}
else
{
  Write-Host
  Write-Host -ForegroundColor Yellow "The connection to Microsoft Graph is still active. To disconnect, use Disconnect-MgGraph"
}
#################################To Here#############

# 2. Save the file. 
# Open PowerShell in the directory that contains RegisterAppOnly.ps1 and run the following command. 
# If you don't already have a certificate, you can create a self-signed certificate using the See also section.
# https://learn.microsoft.com/en-us/powershell/microsoftgraph/app-only?view=graph-powershell-1.0#see-also

.\RegisterAppOnly.ps1 -AppName "Graph PowerShell Script" -CertPath "PATH_TO_PUBLIC_KEY_FILE"

# 3. Open your browser as prompted. Sign in with an administrator account and accept the permissions.

# 4. Review the output for the prompt Please go to the following URL in your browser to provide admin consent. 
#    Copy the URL provided and paste it in your browser. Sign in with an administrator account to grant admin consent to your newly registered application.

# Note: After granting admin consent, the browser will redirect back to http://localhost and display a Not Found error. This error can be ignored as long as the URL contains admin_consent=True.

# 5. Review the rest of the PowerShell output for Connect-MgGraph command pre-filled with the values for your app registration.

### Step 2: Authenticate the application ###

<#
Using that app registration in step 1, you can use the Microsoft Graph PowerShell SDK with app-only access, allowing for unattended scripts.

You should have three pieces of information after completing the configuration steps above.

Certificate subject or thumbprint of the certificate uploaded to your Microsoft Entra app registration.
Application ID for your app registration.
Your tenant ID.
We'll use this information to test authentication. Open PowerShell and run the following command, replacing the placeholders with your information.
#>
Connect-MgGraph -ClientID YOUR_APP_ID -TenantId YOUR_TENANT_ID -CertificateName YOUR_CERT_SUBJECT ## Or -CertificateThumbprint instead of -CertificateName

# If the command succeeds, you see Welcome To Microsoft Graph!. Run Get-MgContext to verify that you authenticated with app-only. The output should look like the following.
<#
ClientId              : YOUR_APP_ID
TenantId              : YOUR_TENANT_ID
CertificateThumbprint :
Scopes                : {Group.Read.All, User.Read.All}
AuthType              : AppOnly
CertificateName       : YOUR_CERT_SUBJECT
Account               :
AppName               : Graph PowerShell Script
ContextScope          : Process
#>

### Steps 3: Create and run a script ###

# Create a new file named GraphAppOnly.ps1 and add the following code.

##################Copy Here###############################
# Authenticate
Connect-MgGraph -ClientID YOUR_APP_ID -TenantId YOUR_TENANT_ID -CertificateName YOUR_CERT_SUBJECT

Write-Host "USERS:"
Write-Host "======================================================"
# List first 50 users
Get-MgUser -Property "id,displayName" -PageSize 50 | Format-Table DisplayName, Id

Write-Host "GROUPS:"
Write-Host "======================================================"
# List first 50 groups
Get-MgGroup -Property "id,displayName" -PageSize 50 | Format-Table DisplayName, Id

# Disconnect
Disconnect-MgGraph
###################To Here######################################3
# Replace the placeholders in the Connect-MgGraph command with your information. Save the file, then open PowerShell in the directory where you created the file. Run the script with the following command.
.\GraphAppOnly.ps1

# We used app-only access to authenticate with Microsoft Graph and list users and groups in our tenant. 
# You can use this same pattern to create scripts that perform any operation supported by the Microsoft Graph PowerShell SDK for non-interactive scenarios.

#endregion

#region Manage Access to Resources https://learn.microsoft.com/en-us/powershell/microsoftgraph/tutorial-entitlement-management?view=graph-powershell-1.0

# Tutorial: Manage access to resources in Microsoft Entra entitlement management using Microsoft Graph PowerShell

<#
Managing access to all the resources that employees need, such as groups, applications, and sites, is an important function for organizations. 
You want to grant employees the right level of access they need to be productive and remove their access when it's no longer needed. 
Microsoft Entra entitlement management using Microsoft Graph PowerShell enables you to manage this type of access.

In this tutorial, you create a package of resources for a marketing campaign that internal users can use for self-service requests. 
Requests don't require approval and users' access expires after 30 days. Here, the marketing campaign resources are just membership in a single group, 
but it could be a collection of groups, applications, or SharePoint Online sites.
#>

<#

Prerequisites
To successfully complete this tutorial, make sure you have the required prerequisites:

Microsoft Graph PowerShell SDK is installed. Follow the installation guide for more info on how to do this.

To use Microsoft Entra entitlement management, you must have Microsoft Entra ID Governance subscriptions for your organization's users. 
Some capabilities within this feature may operate with a Microsoft Entra ID P2 subscription.

Entitlement management is available in the beta and v1 modules of Microsoft Graph PowerShell. This tutorial uses the beta module. 
Ensure that you have both Microsoft.Graph and Microsoft.Graph.Beta modules installed.

Microsoft Graph PowerShell using a Identity Governance Administrator and the appropriate permissions. The User.ReadWrite.All, 
Group.ReadWrite.All, and EntitlementManagement.ReadWrite.All delegated permissions are required. 
#>
#To set the permissions in Microsoft Graph PowerShell, run;

Connect-MgGraph -Scopes "User.ReadWrite.All", "Group.ReadWrite.All", "EntitlementManagement.ReadWrite.All"

# Step 1: Create a user account and a group

#  Create a user account
<#Create a user account that you use later to request access to the resources in the access package.

When you make these calls, change contoso.onmicrosoft.com to the domain name of your tenant. 
You can find tenant information on the Microsoft Entra overview page. Record the value of the returned Id property to use later.
#>
$passwordProfile =@{
  Password = 'Contoso1234'
  ForceChangePasswordNextSignIn = $true
}

New-MgUser -DisplayName 'Requestor1' -PasswordProfile $passwordProfile -AccountEnabled -MailNickName 'Requestor1' -UserPrincipalName 'Requestor1@contoso.onmicrosoft.com'

<#Output
Id                                   DisplayName Mail UserPrincipalName                        UserType
--                                   ----------- ---- -----------------                        --------
6c42590f-fcf0-4922-bac6-205f7c6aa89c Requestor1       Requestor1@contoso.onmicrosoft.com       Member
#>

# Create a group
#Create a group named Marketing resources that is the target resource for entitlement management.

New-MgGroup -DisplayName 'Marketing resources' -Description 'Marketing resources' -MailEnabled: $False -MailNickName 'markres' -SecurityEnabled


# Step 2: Add resources to a catalog and create an access package
<#An access package is a bundle of resources that a team or project needs and is governed by policies. 
Access packages are defined in containers called catalogs. 
Catalogs can reference resources such as groups, apps, and sites that are used in the access package.
In this step, create a Marketing Campaign access package in the General catalog.
#>

#Get the catalog identifier
Get-MgBetaEntitlementManagementAccessPackageCatalog -Filter "DisplayName eq 'General'" |  Format-List

<#OUTPUT
AccessPackageResourceRoles  :
AccessPackageResourceScopes :
AccessPackageResources      :
AccessPackages              :
CatalogStatus               : Published
CatalogType                 : ServiceDefault
CreatedBy                   : Azure AD
CreatedDateTime             : 1/13/2022 6:47:56 AM
Description                 : Built-in catalog.
DisplayName                 : General
Id                          : 88d3e491-5247-4209-9b56-c4c95d9694e9
IsExternallyVisible         : True
ModifiedBy                  : Azure AD
ModifiedDateTime            : 1/13/2022 6:47:56 AM
AdditionalProperties        : {}
#>

# Add the group to the catalog

$accessPackageResource = @{
  "originSystem" = "AadGroup "
  OriginId= "87553228-0d72-4138-890b-36e683f883b7"
}

New-MgBetaEntitlementManagementAccessPackageResourceRequest -CatalogId '88d3e491-5247-4209-9b56-c4c95d9694e9' -RequestType "AdminAdd" -AccessPackageResource $accessPackageResource | Format-List

<#OUTPUT
AccessPackageResource : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageResource
CatalogId             : 88d3e491-5247-4209-9b56-c4c95d9694e9
ExecuteImmediately    : False
ExpirationDateTime    :
Id                    : 5f32e397-18f2-4e5b-9e5e-d17097684442
IsValidationOnly      :
Justification         :
RequestState          : Delivered
RequestStatus         : Fulfilled
RequestType           : AdminAdd
Requestor             : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageSubject1
AdditionalProperties  : {[@odata.context, https://graph.microsoft.com/beta/$metadata#identityGovernance/entitlementManagement/accessPackageResourceRequests/$entity]}
#>

#Get catalog resources

Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResource -AccessPackageCatalogId '88d3e491-5247-4209-9b56-c4c95d9694e9' -Filter "DisplayName eq 'Marketing resources'" | Format-List

<#
AccessPackageResourceEnvironment : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageResourceEnvironment
AccessPackageResourceRoles       :
AccessPackageResourceScopes      :
AddedBy                          : admin@contoso.onmicrosoft.com
AddedOn                          : 4/5/2022 11:33:44 AM
Attributes                       : {}
Description                      : Marketing resources
DisplayName                      : Marketing resources
Id                               : 0a358d7b-42d9-48c5-8455-df23dcaff2ad
IsPendingOnboarding              : False
OriginId                         : 87553228-0d72-4138-890b-36e683f883b7
OriginSystem                     : AadGroup
ResourceType                     : Security Group
Url                              : https://account.activedirectory.windowsazure.com/r?tenantId=06f6521d-c18c-460a-8656-fa82e81aa94b#/manageMembership?objectType=Group&objectId=87553228-0d72-4138-890b-36e683f883b7
AdditionalProperties             : {}
#>

# Get resource roles
Get-MgBetaEntitlementManagementAccessPackageCatalogAccessPackageResourceRole -AccessPackageCatalogId '88d3e491-5247-4209-9b56-c4c95d9694e9' -Filter "originSystem eq 'AadGroup' and accessPackageResource/id eq '0a358d7b-42d9-48c5-8455-df23dcaff2ad' and DisplayName eq 'Member'"

<#
Id                                   Description DisplayName OriginId                                    OriginSystem
--                                   ----------- ----------- --------                                    ------------
00000000-0000-0000-0000-000000000000             Member      Member_87553228-0d72-4138-890b-36e683f883b7 AadGroup
#>

# Create the access package
New-MgBetaEntitlementManagementAccessPackage -CatalogId '88d3e491-5247-4209-9b56-c4c95d9694e9'  -DisplayName 'Marketing Campaign'| 
  Format-List

<#
AccessPackageAssignmentPolicies :
AccessPackageCatalog            : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageCatalog1
AccessPackageResourceRoleScopes :
AccessPackagesIncompatibleWith  :
CatalogId                       : 88d3e491-5247-4209-9b56-c4c95d9694e9
CreatedBy                       : admin@contoso.onmicrosoft.com
CreatedDateTime                 : 4/5/2022 11:40:59 AM
Description                     :
DisplayName                     : Marketing Campaign
Id                              : 08173ced-8eae-4023-8433-cb85f29e7726
IncompatibleAccessPackages      :
IncompatibleGroups              :
IsHidden                        : False
IsRoleScopesVisible             : False
ModifiedBy                      : admin@contoso.onmicrosoft.com
ModifiedDateTime                : 4/5/2022 11:40:59 AM
AdditionalProperties            : {[@odata.context, https://graph.microsoft.com/beta/$metadata#identityGovernance/entitlementManagement/accessPackages/$entity]}
#>

# Add a resource role to the access package

$accessPackageResource = @{
  "id"= '0a358d7b-42d9-48c5-8455-df23dcaff2ad'
  "resourceType" ='Security Group'
  "originId"= '87553228-0d72-4138-890b-36e683f883b7'
  "originSystem"= 'AadGroup'
  }

$accessPackageResourceRole = @{
  "originId"= 'Member_87553228-0d72-4138-890b-36e683f883b7'
  "displayName" = 'Member'
  "originSystem" = 'AadGroup'
  "accessPackageResource" = $accessPackageResource
  }

$accessPackageResourceScope = @{
  "originId" = '87553228-0d72-4138-890b-36e683f883b7'
  "originSystem" ='AadGroup'
  }

New-MgBetaEntitlementManagementAccessPackageResourceRoleScope -AccessPackageId '08173ced-8eae-4023-8433-cb85f29e7726' -AccessPackageResourceRole $accessPackageResourceRole -AccessPackageResourceScope $accessPackageResourceScope | Format-List

<#
AccessPackageResourceRole  : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageResourceRole
AccessPackageResourceScope : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageResourceScope
CreatedBy                  : admin@contoso.onmicrosoft.com
CreatedDateTime            : 4/5/2022 11:48:35 AM
Id                         : 970ea023-669d-49a5-ae4b-642b3c6f403c_fea332ec-06e3-4c35-ad87-c97d79c3bf9b
ModifiedBy                 : admin@contoso.onmicrosoft.com
ModifiedDateTime           : 4/5/2022 11:48:35 AM
AdditionalProperties       : {[@odata.context, https://graph.microsoft.com/beta/$metadata#identityGovernance/entitlementManagement/accessPackages('08173ced-8eae-4023-8433-cb85f29e7726')/accessPackageResourceRoleScopes/$entity]}
#>

# Create an access package policy

$allowedRequestors = @(@{
  "@odata.type" = '#microsoft.graph.singleUser'
  "isBackup" = $false
  "id"= '6c42590f-fcf0-4922-bac6-205f7c6aa89c'
  "description" = 'Requestor1'
  })

$requestorSettings =@{
  "scopeType" = 'SpecificDirectorySubjects'
  "acceptRequests" = $true
  "allowedRequestors" = $allowedRequestors
  }

$requestApprovalSettings = @{
  "isApprovalRequired" = $false
  "isApprovalRequiredForExtension" =$false
  "isRequestorJustificationRequired"= $false
  "approvalMode"= 'NoApproval'
  "approvalStages"= '[]'
  }

New-MgBetaEntitlementManagementAccessPackageAssignmentPolicy -AccessPackageId '08173ced-8eae-4023-8433-cb85f29e7726' -DisplayName 'Specific users' -Description 'Specific users can request assignment'  -DurationInDays 30 -RequestorSettings $requestorSettings -RequestApprovalSettings $requestApprovalSettings | Format-List

<# 
AccessPackage           : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackage
AccessPackageCatalog    : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageCatalog1
AccessPackageId         : 08173ced-8eae-4023-8433-cb85f29e7726
AccessReviewSettings    : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAssignmentReviewSettings
CanExtend               : True
CreatedBy               : admin@contoso.onmicrosoft.com
CreatedDateTime         : 4/5/2022 11:53:36 AM
Description             : Specific users can request assignment
DisplayName             : Specific users
DurationInDays          : 30
ExpirationDateTime      :
Id                      : 4acf0d48-49b1-495b-816e-58933c9a9e64
ModifiedBy              : admin@contoso.onmicrosoft.com
ModifiedDateTime        : 4/5/2022 11:53:36 AM
Questions               : {}
RequestApprovalSettings : Microsoft.Graph.PowerShell.Models.MicrosoftGraphApprovalSettings
RequestorSettings       : Microsoft.Graph.PowerShell.Models.MicrosoftGraphRequestorSettings
AdditionalProperties    : {[@odata.context, https://graph.microsoft.com/beta/$metadata#identityGovernance/entitlementManagement/accessPackageAssignmentPolicies/$entity]}
#>
# Step 3: Request access

New-MgBetaEntitlementManagementAccessPackageAssignmentRequest -RequestType 'UserAdd' -AccessPackageId '08173ced-8eae-4023-8433-cb85f29e7726' -AssignmentPolicyId '4acf0d48-49b1-495b-816e-58933c9a9e64' -TargetId '6c42590f-fcf0-4922-bac6-205f7c6aa89c'

<#
Id                                   CompletedDate CreatedDateTime ExpirationDateTime IsValidationOnly Justification RequestState RequestStatus RequestType
--                                   ------------- --------------- ------------------ ---------------- ------------- ------------ ------------- -----------
bff7d893-dc69-4f69-ae9f-24ce60531c37                                                  False                          Submitted    Accepted      UserAdd
#>

# Step 4: Validate that access has been assigned

Get-MgBetaEntitlementManagementAccessPackageAssignmentRequest -AccessPackageAssignmentRequestId '2276a78f-b1a1-471c-b69f-04649b2aaa92'| Format-List

<#
AccessPackage           : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackage
AccessPackageAssignment : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageAssignment
Answers                 : {}
CompletedDate           : 4/5/2022 12:05:31 PM
CreatedDateTime         : 4/5/2022 12:05:25 PM
ExpirationDateTime      :
Id                      : 2276a78f-b1a1-471c-b69f-04649b2aaa92
IsValidationOnly        : False
Justification           :
RequestState            : Delivered
RequestStatus           : FulfilledNotificationTriggered
RequestType             : UserAdd
Requestor               : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageSubject1
Schedule                : Microsoft.Graph.PowerShell.Models.MicrosoftGraphRequestSchedule
AdditionalProperties    : {[@odata.context, https://graph.microsoft.com/beta/$metadata#identityGovernance/entitlementManagement/accessPackageAssignmentRequests/$entity], [customExtensionHandlerInstances, System.Object[]]}
#>

# Get access package assignments

Get-MgBetaEntitlementManagementAccessPackageAssignment -Filter "(AccessPackageAssignmentPolicy/Id eq '4acf0d48-49b1-495b-816e-58933c9a9e64')" | Format-List

<#
AccessPackage                        : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackage
AccessPackageAssignmentPolicy        : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageAssignmentPolicy
AccessPackageAssignmentRequests      :
AccessPackageAssignmentResourceRoles :
AccessPackageId                      : 08173ced-8eae-4023-8433-cb85f29e7726
AssignmentPolicyId                   : 4acf0d48-49b1-495b-816e-58933c9a9e64
AssignmentState                      : Delivered
AssignmentStatus                     : Delivered
CatalogId                            : 88d3e491-5247-4209-9b56-c4c95d9694e9
ExpiredDateTime                      :
Id                                   : eff960a2-6b20-4611-81c2-cb3d183584d9
IsExtended                           : False
Schedule                             : Microsoft.Graph.PowerShell.Models.MicrosoftGraphRequestSchedule
Target                               : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAccessPackageSubject1
TargetId                             : 6c42590f-fcf0-4922-bac6-205f7c6aa89c
AdditionalProperties                 : {}
#>

# Get the members of the group
Get-MgGroupMember -GroupId '87553228-0d72-4138-890b-36e683f883b7'
<#
Id                                   DeletedDateTime
--                                   ---------------
6c42590f-fcf0-4922-bac6-205f7c6aa89c
#>

# Step 5: Clean up the resources
#In this step, remove the changes you made and delete the Marketing Campaign access package.

# Remove an access package assignment
New-MgBetaEntitlementManagementAccessPackageAssignmentRequest -RequestType 'AdminRemove' -AccessPackageAssignmentId 'eff960a2-6b20-4611-81c2-cb3d183584d9'
<#
Id                                   CompletedDate CreatedDateTime ExpirationDateTime IsValidationOnly Justification RequestState RequestStatus RequestType
--                                   ------------- --------------- ------------------ ---------------- ------------- ------------ ------------- -----------
8b8e68a8-609c-4535-a9fd-f49713e46e6f                                                  False                          Submitted    Accepted      AdminRemove
#>

# Delete the access package assignment policy
Remove-MgBetaEntitlementManagementAccessPackage -AccessPackageId '08173ced-8eae-4023-8433-cb85f29e7726'

# Delete the access package
Remove-MgBetaEntitlementManagementAccessPackage -AccessPackageId '08173ced-8eae-4023-8433-cb85f29e7726'

# Delete the user account
Remove-MgUser -UserId '6c42590f-fcf0-4922-bac6-205f7c6aa89c'

# Delete the group
Remove-MgGroup -GroupId '87553228-0d72-4138-890b-36e683f883b7'

#endregion

#PIM Priviledged Identity Management

#region Assign Microsoft Entra roles in Privileged Identity Management using Microsoft Graph PowerShell

<#Prerequisites
To successfully complete this guide, make sure you have the required prerequisites:

Microsoft Graph PowerShell SDK is installed. Follow the Install the Microsoft Graph PowerShell SDK guide to install the SDK.

To use the Microsoft Entra Privileged Identity Management, you must have one of the following licenses:

Microsoft Entra ID P2
Enterprise Mobility + Security (EMS) E5 license
Microsoft Graph PowerShell using a Privileged Role Administrator role and the appropriate permissions. For this guide, the RoleManagement.ReadWrite.Directory delegated permission is required. To set the permissions in Microsoft Graph PowerShell, run;
#>

Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory"

# Step 1: Create a user account

$passwordProfile =@{
  Password = 'Contoso1234'
  ForceChangePasswordNextSignIn = $true
}

New-MgUser -DisplayName 'Requestor1' -PasswordProfile $passwordProfile -AccountEnabled -MailNickName 'Requestor1' -UserPrincipalName 'Requestor1@Contoso.onmicrosoft.com'

<#
Id                                   DisplayName Mail UserPrincipalName                        UserType
--                                   ----------- ---- -----------------                        --------
d29e358a-a443-4d83-98b3-499a5405bb5b Requestor1       Requestor1@Contoso.onmicrosoft.com
#>

# Step 2: Create an eligible role assignment for the user for 10 hours

$params = @{
  "PrincipalId" = "d29e358a-a443-4d83-98b3-499a5405bb5b"
  "RoleDefinitionId" = "88d8e3e3-8f55-4a1e-953a-9b9898b8876b"
  "Justification" = "Add eligible assignment"
  "DirectoryScopeId" = "/"
  "Action" = "AdminAssign"
  "ScheduleInfo" = @{
    "StartDateTime" = Get-Date
    "Expiration" = @{
      "Type" = "AfterDuration"
      "Duration" = "PT10H"
      }
    }
   }

New-MgRoleManagementDirectoryRoleEligibilityScheduleRequest -BodyParameter $params | 
  Format-List Id, Status, Action, AppScopeId, DirectoryScopeId, RoleDefinitionId, IsValidationOnly, Justification, PrincipalId, CompletedDateTime, CreatedDateTime

<# Output
Id                : b1fca5a5-24d7-42c1-a7b5-19eed3b306e4
Status            : Provisioned
Action            : AdminAssign
AppScopeId        :
DirectoryScopeId  : /
RoleDefinitionId  : 88d8e3e3-8f55-4a1e-953a-9b9898b8876b
IsValidationOnly  : False
Justification     : Add eligible assignment
PrincipalId       : d29e358a-a443-4d83-98b3-499a5405bb5b
CompletedDateTime : 3/31/2022 3:15:10 PM
CreatedDateTime   : 3/31/2022 3:15:08 PM
#>

# To get all the all eligible role assignments for this user, run:

Get-MgRoleManagementDirectoryRoleEligibilityScheduleInstance -Filter "principalId eq 'd29e358a-a443-4d83-98b3-499a5405bb5b'"  | Format-List

<# Output
AppScope                  : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAppScope
AppScopeId                :
DirectoryScope            : Microsoft.Graph.PowerShell.Models.MicrosoftGraphDirectoryObject
DirectoryScopeId          : /
EndDateTime               : 4/1/2022 1:15:10 AM
Id                        : 4-PYiFWPHkqVOpuYmLiHa4o1ntJDpINNmLNJmlQFu1s-1-e
MemberType                : Direct
Principal                 : Microsoft.Graph.PowerShell.Models.MicrosoftGraphDirectoryObject
PrincipalId               : d29e358a-a443-4d83-98b3-499a5405bb5b
RoleDefinition            : Microsoft.Graph.PowerShell.Models.MicrosoftGraphUnifiedRoleDefinition
RoleDefinitionId          : 88d8e3e3-8f55-4a1e-953a-9b9898b8876b
RoleEligibilityScheduleId : b1fca5a5-24d7-42c1-a7b5-19eed3b306e4
StartDateTime             : 3/31/2022 3:15:10 PM
AdditionalProperties      : {}
#>

# Step 3: Extend eligible role assignment for the user to one day
$params = @{
  "PrincipalId" = "d29e358a-a443-4d83-98b3-499a5405bb5b"
  "RoleDefinitionId" = "88d8e3e3-8f55-4a1e-953a-9b9898b8876b"
  "Justification" = "Extend eligible assignment"
  "DirectoryScopeId" = "/"
  "Action" = "AdminExtend"
  "ScheduleInfo" = @{
    "StartDateTime" = Get-Date
    "Expiration" = @{
      "Type" = "AfterDateTime"
      "EndDateTime" = (Get-Date).AddDays(1)
      }
  }
}

New-MgRoleManagementDirectoryRoleEligibilityScheduleRequest -BodyParameter $params |
  Format-List Id, Status, Action, AppScopeId, DirectoryScopeId, RoleDefinitionID, IsValidationOnly, Justification, PrincipalId, CompletedDateTime, CreatedDateTime, TargetScheduleID

<#Output
Id                : ba52ac85-adac-480f-a9ef-080481d0cdde
Status            : Provisioned
Action            : AdminExtend
AppScopeId        :
DirectoryScopeId  : /
RoleDefinitionId  : 88d8e3e3-8f55-4a1e-953a-9b9898b8876b
IsValidationOnly  : False
Justification     : Extend eligible assignment
PrincipalId       : d29e358a-a443-4d83-98b3-499a5405bb5b
CompletedDateTime : 3/31/2022 3:32:19 PM
CreatedDateTime   : 3/31/2022 3:32:16 PM
TargetScheduleId  : ba52ac85-adac-480f-a9ef-080481d0cdde
#>

# Step 4: User activates eligible assignment for 1 hour

$params = @{
  "PrincipalId" = "d29e358a-a443-4d83-98b3-499a5405bb5b"
  "RoleDefinitionId" = "88d8e3e3-8f55-4a1e-953a-9b9898b8876b"
  "Justification" = "Activate assignment"
  "DirectoryScopeId" = "/"
  "Action" = "SelfActivate"
  "ScheduleInfo" = @{
    "StartDateTime" = Get-Date
    "Expiration" = @{
       "Type" = "AfterDuration"
       "Duration" = "PT1H"
       }
     }
    }

New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest -BodyParameter $params |
  Format-List Id, Status, Action, AppScopeId, DirectoryScopeId, RoleDefinitionID, IsValidationOnly, Justification, PrincipalId, CompletedDateTime, CreatedDateTime, TargetScheduleID

<#Output
Id                : e8eb8d47-98a8-4868-9174-7d25bdab8f2f
Status            : Provisioned
Action            : SelfActivate
AppScopeId        :
DirectoryScopeId  : /
RoleDefinitionId  : 88d8e3e3-8f55-4a1e-953a-9b9898b8876b
IsValidationOnly  : False
Justification     : Activate assignment
PrincipalId       : d29e358a-a443-4d83-98b3-499a5405bb5b
CompletedDateTime : 3/31/2022 3:33:44 PM
CreatedDateTime   : 3/31/2022 3:33:42 PM
TargetScheduleId  : e8eb8d47-98a8-4868-9174-7d25bdab8f2f
#>

# To get the existing active role assignments for this user, run:

Get-MgRoleManagementDirectoryRoleAssignmentScheduleInstance -Filter "principalId eq 'd29e358a-a443-4d83-98b3-499a5405bb5b'" | Format-List

<#Output
ActivatedUsing           : Microsoft.Graph.PowerShell.Models.MicrosoftGraphUnifiedRoleEligibilityScheduleInstance
AppScope                 : Microsoft.Graph.PowerShell.Models.MicrosoftGraphAppScope
AppScopeId               :
AssignmentType           : Activated
DirectoryScope           : Microsoft.Graph.PowerShell.Models.MicrosoftGraphDirectoryObject
DirectoryScopeId         : /
EndDateTime              : 3/31/2022 4:33:44 PM
Id                       : 4-PYiFWPHkqVOpuYmLiHa4o1ntJDpINNmLNJmlQFu1s-1
MemberType               : Direct
Principal                : Microsoft.Graph.PowerShell.Models.MicrosoftGraphDirectoryObject
PrincipalId              : d29e358a-a443-4d83-98b3-499a5405bb5b
RoleAssignmentOriginId   : 4-PYiFWPHkqVOpuYmLiHa4o1ntJDpINNmLNJmlQFu1s-1
RoleAssignmentScheduleId : e8eb8d47-98a8-4868-9174-7d25bdab8f2f
RoleDefinition           : Microsoft.Graph.PowerShell.Models.MicrosoftGraphUnifiedRoleDefinition
RoleDefinitionId         : 88d8e3e3-8f55-4a1e-953a-9b9898b8876b
StartDateTime            : 3/31/2022 3:33:45 PM
AdditionalProperties     : {}
#>

# Step 5: User deactivates an active role assignment

$params = @{
  "PrincipalId" = "d29e358a-a443-4d83-98b3-499a5405bb5b"
  "RoleDefinitionId" = "88d8e3e3-8f55-4a1e-953a-9b9898b8876b"
  "Justification" = "Deactivate assignment"
  "DirectoryScopeId" = "/"
  "Action" = "SelfDeactivate"
  }

New-MgRoleManagementDirectoryRoleAssignmentScheduleRequest -BodyParameter $params |
  Format-List Id, Status, Action, AppScopeId, DirectoryScopeId, RoleDefinitionID, IsValidationOnly, Justification, PrincipalId, CompletedDateTime, CreatedDateTime, TargetScheduleID

<#OUtput
Id                : 93ae4df7-1253-459f-8a13-9aa12e8438c1
Status            : Revoked
Action            : SelfDeactivate
AppScopeId        :
DirectoryScopeId  : /
RoleDefinitionId  : 88d8e3e3-8f55-4a1e-953a-9b9898b8876b
IsValidationOnly  : False
Justification     : Deactivate assignment
PrincipalId       : d29e358a-a443-4d83-98b3-499a5405bb5b
CompletedDateTime :
CreatedDateTime   : 3/31/2022 3:39:05 PM
TargetScheduleId  :
#>

# Step 6: Admin removes an eligible assignment

$params = @{
  "PrincipalId" = "d29e358a-a443-4d83-98b3-499a5405bb5b"
  "RoleDefinitionId" = "88d8e3e3-8f55-4a1e-953a-9b9898b8876b"
  "Justification" = "Remove eligible assignment"
  "DirectoryScopeId" = "/"
  "Action" = "AdminRemove"
}

New-MgRoleManagementDirectoryRoleEligibilityScheduleRequest -BodyParameter $params |
  Format-List Id, Status, Action, AppScopeId, DirectoryScopeId, RoleDefinitionID, IsValidationOnly, Justification, PrincipalId, CompletedDateTime, CreatedDateTime, TargetScheduleID

<#Output
Id                : d11c9bd1-869a-4401-8f92-3da531c49d82
Status            : Revoked
Action            : AdminRemove
AppScopeId        :
DirectoryScopeId  : /
RoleDefinitionId  : 88d8e3e3-8f55-4a1e-953a-9b9898b8876b
IsValidationOnly  : False
Justification     : Remove eligible assignment
PrincipalId       : d29e358a-a443-4d83-98b3-499a5405bb5b
CompletedDateTime :
CreatedDateTime   : 3/31/2022 3:42:31 PM
TargetScheduleId  :
#>

#endregion

#region Manage PIM policies https://learn.microsoft.com/en-us/powershell/microsoftgraph/how-to-manage-pim-policies?view=graph-powershell-1.0

#Manage PIM policies in Microsoft Graph PowerShell

<#Prerequisites
To successfully complete this guide, make sure you have the required prerequisites:

Microsoft Graph PowerShell SDK is installed. Follow the Install the Microsoft Graph PowerShell SDK guide to install the SDK.

To use the Microsoft Entra Privileged Identity Management, you must have one of the following licenses:

Microsoft Entra ID P2
Enterprise Mobility + Security (EMS) E5 license
Microsoft Graph PowerShell using a Privileged Role Administrator and the appropriate permissions. For this how-to guide, the RoleManagement.ReadWrite.Directory delegated permission is required. To set the permissions in Microsoft Graph PowerShell, run;
#>

Connect-MgGraph -Scopes "RoleManagement.ReadWrite.Directory"


#Step 1: List policies

Get-MgPolicyRoleManagementPolicy -Filter "scopeId eq '/' and scopeType eq 'DirectoryRole'"

<#Output
Id                                                                                      Description   DisplayName   IsOrganizationDefault LastModifiedDateTime ScopeId ScopeType
--                                                                                      -----------   -----------   --------------------- -------------------- ------- ---------
DirectoryRole_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720 DirectoryRole DirectoryRole False                                      /       DirectoryRole
DirectoryRole_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_04949382-ea50-4d50-8d4e-a89801b95dc2 DirectoryRole DirectoryRole False                                      /       DirectoryRole
DirectoryRole_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_5e870933-40ea-48d6-a77f-b8813f9172c2 DirectoryRole DirectoryRole False                                      /       DirectoryRole
DirectoryRole_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_dbc3fbda-6dfe-4e3f-9a93-e7afc047dc6b DirectoryRole DirectoryRole False                                      /       DirectoryRole
DirectoryRole_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_2a5f1b68-1022-41a6-be9a-fa022b1d1670 DirectoryRole DirectoryRole False                                      /       DirectoryRole
DirectoryRole_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_98664ea2-fcb2-4dee-a42d-4891d18df7d6 DirectoryRole DirectoryRole False                                      /       DirectoryRole
DirectoryRole_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_c7645eec-de95-4c56-8516-eea261ddf063 DirectoryRole DirectoryRole False                                      /       DirectoryRole
DirectoryRole_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_e7701331-5e4b-42cb-98b5-04b12e9b780d DirectoryRole DirectoryRole False                                      /       DirectoryRole
DirectoryRol
#>

#List details of a specific policy

$policyId = "DirectoryRole_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720"

Get-MgPolicyRoleManagementPolicy -UnifiedRoleManagementPolicyId $policyId | Format-List

<#OP
Description           : DirectoryRole
DisplayName           : DirectoryRole
EffectiveRules        :
Id                    : DirectoryRole_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720
IsOrganizationDefault : False
LastModifiedBy        : Microsoft.Graph.PowerShell.Models.MicrosoftGraphIdentity
LastModifiedDateTime  :
Rules                 :
ScopeId               : /
ScopeType             : DirectoryRole
AdditionalProperties  : {[@odata.context, https://graph.microsoft.com/v1.0/$metadata#policies/roleManagementPolicies/$entity]}
#>

#Step 2: Get policy assignments

#To get all the policy assignments, run:
Get-MgPolicyRoleManagementPolicyAssignment -Filter "scopeId eq '/' and scopeType eq 'Directory'"

<#Output
Id                                                                                                                       PolicyId                                                                            RoleDefinitionId                     ScopeId ScopeType
--                                                                                                                       --------                                                                            ----------------                     ------- ---------
Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720_88d8e3e3-8f55-4a1e-953a-9b9898b8876b Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720 88d8e3e3-8f55-4a1e-953a-9b9898b8876b /       Directory
Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_5e870933-40ea-48d6-a77f-b8813f9172c2_10dae51f-b6af-4016-8d66-8c2a99b929b3 Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_5e870933-40ea-48d6-a77f-b8813f9172c2 10dae51f-b6af-4016-8d66-8c2a99b929b3 /       Directory
Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_dbc3fbda-6dfe-4e3f-9a93-e7afc047dc6b_2af84b1e-32c8-42b7-82bc-daa82404023b Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_dbc3fbda-6dfe-4e3f-9a93-e7afc047dc6b 2af84b1e-32c8-42b7-82bc-daa82404023b /       Directory
Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_2a5f1b68-1022-41a6-be9a-fa022b1d1670_95e79109-95c0-4d8e-aee3-d01accf2d47b Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_2a5f1b68-1022-41a6-be9a-fa022b1d1670 95e79109-95c0-4d8e-aee3-d01accf2d47b /       Directory
#>

#To get a specific policy assignment, run:
$assignmentId = "Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720_88d8e3e3-8f55-4a1e-953a-9b9898b8876b"

Get-MgPolicyRoleManagementPolicyAssignment -UnifiedRoleManagementPolicyAssignmentId $assignmentId | Format-List

<#Output
Id                   : Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720_88d8e3e3-8f55-4a1e-953a-9b9898b8876b
Policy               : Microsoft.Graph.PowerShell.Models.MicrosoftGraphUnifiedRoleManagementPolicy
PolicyId             : Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720
RoleDefinitionId     : 88d8e3e3-8f55-4a1e-953a-9b9898b8876b
ScopeId              : /
ScopeType            : Directory
AdditionalProperties : {[@odata.context, https://graph.microsoft.com/v1.0/$metadata#policies/roleManagementPolicyAssignments/$entity]}
#>

#Step 3: Get policy rules

# To get all the rules for a policy, run:
$policyId = "Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720"
Get-MgPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $policyId | Format-List

<#Output
Id                   : Expiration_Admin_Eligibility
Target               : Microsoft.Graph.PowerShell.Models.MicrosoftGraphUnifiedRoleManagementPolicyRuleTarget
AdditionalProperties : {[@odata.type, #microsoft.graph.unifiedRoleManagementPolicyExpirationRule], [isExpirationRequired, False], [maximumDuration, P365D]}

Id                   : Enablement_Admin_Eligibility
Target               : Microsoft.Graph.PowerShell.Models.MicrosoftGraphUnifiedRoleManagementPolicyRuleTarget
AdditionalProperties : {[@odata.type, #microsoft.graph.unifiedRoleManagementPolicyEnablementRule], [enabledRules, System.Object[]]}
#>

# To get the details of a specific rule for a policy, run:
$policyId = "Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720"

$ruleId = "Expiration_EndUser_Assignment"

Get-MgPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $policyId -UnifiedRoleManagementPolicyRuleId $ruleId | Format-List

<#Output
Id                   : Expiration_EndUser_Assignment
Target               : Microsoft.Graph.PowerShell.Models.MicrosoftGraphUnifiedRoleManagementPolicyRuleTarget
AdditionalProperties : {[@odata.context, https://graph.microsoft.com/v1.0/$metadata#policies/roleManagementPolicies('Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720')/rules/$entity], [@odata.type,
                       #microsoft.graph.unifiedRoleManagementPolicyExpirationRule], [isExpirationRequired, True], [maximumDuration, PT8H]}
#>

#   Step 4: Update a policy rule
# In this step, we'll update the Expiration_EndUser_Assignment rule.

$policyId = "Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720"

$ruleId = "Expiration_EndUser_Assignment"

$params = @{
"@odata.type" = "#microsoft.graph.unifiedRoleManagementPolicyExpirationRule"
Id = "Expiration_EndUser_Assignment"
isExpirationRequired = $false
maximumDuration = "P365D"
Target = @{
  "@odata.type" = "microsoft.graph.unifiedRoleManagementPolicyRuleTarget"
  Caller = "EndUser"
  Operations = @(
     "all"
     )
  Level = "Assignment"
  InheritableSettings = @(
  )
  EnforcedSettings = @(
  )
  }
}

Update-MgPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $policyId -UnifiedRoleManagementPolicyRuleId $ruleId -BodyParameter $params

#You can check the updated rule by running the following command:
Get-MgPolicyRoleManagementPolicyRule -UnifiedRoleManagementPolicyId $policyId -UnifiedRoleManagementPolicyRuleId $ruleId | Format-List

<#Output
Id                   : Expiration_EndUser_Assignment
Target               : Microsoft.Graph.PowerShell.Models.MicrosoftGraphUnifiedRoleManagementPolicyRuleTarget
AdditionalProperties : {[@odata.context, https://graph.microsoft.com/v1.0/$metadata#policies/roleManagementPolicies('Directory_f54257c3-0b0f-4dd1-b7d9-8a20d8f57f8b_181f1c72-4d0e-4e3c-902d-ad08d070e720')/rules/$entity], [@odata.type,
                       #microsoft.graph.unifiedRoleManagementPolicyExpirationRule], [isExpirationRequired, False], [maximumDuration, P365D]}
#>



#endregion

#region Grant API Permissions https://learn.microsoft.com/en-us/powershell/microsoftgraph/how-to-grant-revoke-api-permissions?view=graph-powershell-1.0

# Grant and revoke API permissions in Microsoft Entra ID

# In this article, you grant and revoke delegated permissions that are exposed by an API to an app. Delegated permissions, 
# also called scopes or OAuth2 permissions, allow an app to call an API on behalf of a signed-in user.


<#Prerequisites
To successfully complete this guide, make sure you have the required prerequisites:

A working Microsoft Entra tenant.

Microsoft Graph PowerShell SDK is installed. Follow the Install the Microsoft Graph PowerShell SDK guide to install the SDK.

Microsoft Graph PowerShell using a Privileged Role Administrator, Application Administrator, or a Cloud Application Administrator in the tenant and the appropriate permissions. 
For this guide, the Application.Read.All and DelegatedPermissionGrant.ReadWrite.All delegated permissions are required. To set the permissions in Microsoft Graph PowerShell, run:
#>

Connect-MgGraph -Scopes "Application.ReadWrite.All", "DelegatedPermissionGrant.ReadWrite.All"

# Step 1: Get the delegated permissions of the resource service principal

Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'" -Property Oauth2PermissionScopes | Select-Object -ExpandProperty Oauth2PermissionScopes | Format-List

<#Output
AdminConsentDescription : Allows the app to read and write the full set of profile properties, reports, and managers of other users in your organization, on behalf of the signed-in user.
AdminConsentDisplayName : Read and write all users' full profiles
Id                      : 204e0828-b5ca-4ad8-b9f3-f32a958e7cc4
IsEnabled               : True
Origin                  :
Type                    : Admin
UserConsentDescription  : Allows the app to read and write the full set of profile properties, reports, and managers of other users in your organization, on your behalf.
UserConsentDisplayName  : Read and write all users' full profiles
Value                   : User.ReadWrite.All
AdditionalProperties    : {}

AdminConsentDescription : Allows the app to list groups, and to read their properties and all group memberships on behalf of the signed-in user.  Also allows the app to read calendar, conversations, files,
                          and other group content for all groups the signed-in user can access.
AdminConsentDisplayName : Read all groups
Id                      : 5f8c59db-677d-491f-a6b8-5f174b11ec1d
IsEnabled               : True
Origin                  :
Type                    : Admin
UserConsentDescription  : Allows the app to list groups, and to read their properties and all group memberships on your behalf.  Also allows the app to read calendar, conversations, files, and other group
                          content for all groups you can access.
UserConsentDisplayName  : Read all groups
Value                   : Group.Read.All
AdditionalProperties    : {}
#>

# Step 2: Create a client service principal

#   Register an application with Microsoft Entra ID

New-MgApplication -DisplayName 'My application' | 
  Format-List Id, DisplayName, AppId, SignInAudience, PublisherDomain

<#Output
Id              : 40cbfad6-f138-4fb4-9e7f-5a44044efbd6
DisplayName     : My application
AppId           : 00001111-aaaa-2222-bbbb-3333cccc4444
SignInAudience  : AzureADandPersonalMicrosoftAccount
PublisherDomain : Contoso.com
#>

# Create a service principal for the application

New-MgServicePrincipal -AppId '00001111-aaaa-2222-bbbb-3333cccc4444' | 
  Format-List Id, DisplayName, AppId, SignInAudience

<#Output
Id             : 11112222-bbbb-3333-cccc-4444dddd5555
DisplayName    : My application
AppId          : 00001111-aaaa-2222-bbbb-3333cccc4444
SignInAudience : AzureADandPersonalMicrosoftAccount
#>

#  Step 3: Grant delegated permissions to the client enterprise application

$resource = Get-MgServicePrincipal -Filter "displayName eq 'Microsoft Graph'"
$params = @{
  "ClientId" = "11112222-bbbb-3333-cccc-4444dddd5555"
  "ConsentType" = "AllPrincipals"
  "ResourceId" = $resource.Id
  "Scope" = "Group.Read.All"
}

New-MgOauth2PermissionGrant -BodyParameter $params | 
  Format-List Id, ClientId, ConsentType, ExpiryTime, PrincipalId, ResourceId, Scope

<#Output
Id          : DXfBIt8w50mnY_OdLvmzadDQeqbRp9tKjNm83QyGbTw
ClientId    : 11112222-bbbb-3333-cccc-4444dddd5555
ConsentType : AllPrincipals
PrincipalId :
ResourceId  : 11112222-bbbb-3333-cccc-4444dddd5555
Scope       : Group.Read.All
#>

# To confirm the delegated permissions assigned to the service principal on behalf of the user, you run the following command.

Get-MgOauth2PermissionGrant -Filter "clientId eq '11112222-bbbb-3333-cccc-4444dddd5555' and consentType eq 'AllPrincipals'" | Format-List

<#Output
ClientId             : 11112222-bbbb-3333-cccc-4444dddd5555
ConsentType          : AllPrincipals
Id                   : DXfBIt8w50mnY_OdLvmzadDQeqbRp9tKjNm83QyGbTw
PrincipalId          :
ResourceId           : 11112222-bbbb-3333-cccc-4444dddd5555
Scope                : Group.Read.All User.Read.All
AdditionalProperties : {}
#>

# Step 4: Grant more delegated permissions to the enterprise application

$params = @{
  Scope = "Group.Read.All User.Read.All"
  }

Update-MgOauth2PermissionGrant -OAuth2PermissionGrantId 'DXfBIt8w50mnY_OdLvmzadDQeqbRp9tKjNm83QyGbTw' -BodyParameter $params

# Step 5: Revoke delegated permissions granted to an enterprise application

$params = @{
  Scope = "Group.Read.All"
  }

Update-MgOauth2PermissionGrant -OAuth2PermissionGrantId 'DXfBIt8w50mnY_OdLvmzadDQeqbRp9tKjNm83QyGbTw' -BodyParameter $params

# Use Remove-MgOauth2PermissionGrant to revoke all grants.

Remove-MgOauth2PermissionGrant -OAuth2PermissionGrantId 'DXfBIt8w50mnY_OdLvmzadDQeqbRp9tKjNm83QyGbTw'

#endregion

#Query Parameters

#region Use Query Parameters

#   Use query parameters to customize PowerShell query outputs

# OData system query options

# -Count
Get-MgUser -ConsistencyLevel eventual -Count count
$count
# -Expand
Get-MgGroup -GroupId '0e06b38f-931a-47db-9a9a-60ab5f492005' -Expand members | Select-Object -ExpandProperty members
Get-MgGroup -GroupId '0e06b38f-931a-47db-9a9a-60ab5f492005' -Expand members | 
  Select-Object -ExpandProperty members |
  Select-Object -ExpandProperty Id
# -Filter
Get-MgUser -Filter "startsWith(DisplayName, 'Conf')"
Get-MgUser -Filter "startsWith(DisplayName, 'J')"
Get-MgUser -Filter "DisplayName eq 'Lee Gu'"
  #startsWith
  #endsWith
  #contains

# -OrderBy
Get-MgUser -OrderBy DisplayName
# -Search
Get-MgUser -ConsistencyLevel eventual -Search '"DisplayName:Conf"'
Get-MgUser -ConsistencyLevel eventual -Count UserCount -Search '"DisplayName:De"'
# -Property
Get-MgUser -Property Id, DisplayName | Select-Object Id, DisplayName
# -Top
Get-MgUser -Top 10

#endregion

#Cmdlet map https://learn.microsoft.com/en-us/powershell/microsoftgraph/azuread-msoline-cmdlet-map?view=graph-powershell-1.0









