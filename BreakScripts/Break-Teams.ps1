Break;

Update-Module -Name microsoftteams

New-Team -DisplayName "Marketing Team"

Get-CsTeamTemplateList

Set-Team -GroupId 267b1d2d-3a88-4f7e-84a4-00276b03bb07 -MailNickName "MarketingTeam"

Add-TeamUser -GroupId 267b1d2d-3a88-4f7e-84a4-00276b03bb07 -User ben@pinkdolphinterritory.com -Role Member

