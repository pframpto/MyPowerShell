break;
# to miniminise block control k and control 0 
get-module -Name microsoft.graph -ListAvailable

Update-Module Microsoft.Graph

Find-MgGraphCommand -command Get-MgUser | Select -First 1 -ExpandProperty Permissions

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

man Find-MgGraphCommand -Examples

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

Get-MgContext | Select -ExpandProperty Scopes

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
Find-MgGraphCommand -command Get-MgUser | Select -First 1 -ExpandProperty Permissions

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



#endregion