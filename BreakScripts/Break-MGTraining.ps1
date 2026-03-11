break;

get-module -Name microsoft.graph -ListAvailable

Update-Module Microsoft.Graph

Find-MgGraphCommand -command Get-MgUser | Select -First 1 -ExpandProperty Permissions


Connect-MgGraph -Scopes "User.Read.All","Group.ReadWrite.All"

get-mguser

