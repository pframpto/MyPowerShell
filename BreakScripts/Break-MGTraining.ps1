break;

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