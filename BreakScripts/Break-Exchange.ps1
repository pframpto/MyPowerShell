Break;

Get-Mailbox

#region Creating a PST
New-MailboxExportRequest -Mailbox Mailbox -FilePath '\\fileserver\psts\Mailbox.pst' 
New-MailboxExportRequest -Mailbox Mailbox -FilePath '\\fileserver\psts\Mailbox.pst' -IsArchive
    
#endregion
    
#region Groups
    New-DistributionGroup -Name "Research Department" -alias researchusers -MemberDepartRestriction open
    Remove-DistributionGroupMember -Identity 'DistributionGroup' -Member memberToRemove
    Add-DistributionGroupMember -Identity 'DistributionGroup' -Member memberToAdd
    
#endregion
    
#region Add and Remove Permissions
"Adding Calendar Permission"
add-MailboxFolderPermission -Identity SharingUser":\calendar" -User ShareeUser -AccessRights owner
Remove-MailboxFolderPermission -Identity SharingUser":\calendar" -User ShareeUser
Add-PublicFolderClientPermission -Identity "\pubicFolderName" -AccessRights owner -User User
    
Add-MailboxPermission SharingUsersMailbox -AccessRights fullaccess,deleteitem -User SharedWithUser -AutoMapping $true
Remove-MailboxPermission SharingUsersMailbox -AccessRights fullaccess,deleteitem -User SharedWithUser
    
#endregion
    
#region SendAs and SendOnBehalf
    #SendAs
    Add-ADPermission -Identity $sharingMailboxID -User SharedWithUser -AccessRights ExtendedRight -ExtendedRights "send as" 
    #SendOnBefalf
    Set-Mailbox sharingMailbox -GrantSendOnBehalfTo sharedWithUser 
    #O365 Sendas
    Add-RecipientPermission Rob.Smith@example.mail.onmicrosoft.com -Trustee me@example.com -AccessRights sendas
    remove-RecipientPermission Rob.Smith@example.mail.onmicrosoft.com -Trustee me@example.com -AccessRights sendas
    
#endregion
    
#region Forwarding
Set-Mailbox -Identity "forwardingMailbox@example.com.au" -ForwardingAddress  "ForwardedToMailbox@example.com.au" -DeliverToMailboxAndForward $true
    #removing Forwarding
    Set-Mailbox -Identity "forwardingingUser" -ForwardingAddress $null -DeliverToMailboxAndForward $false
#endregion
    
#region GAL and Address Lists
    #Remove from GAL
    Get-Mailbox removedFromGalMailbox | Set-Mailbox -HiddenFromAddressListsEnabled $true
    #Updating Address lists
    Get-GlobalAddresslist | Update-GlobalAddressList
    Get-AddressList | Update-AddressList
    restart-service MSExchangeFDS
    
#endregion
    
    
#region move mailbox
    Get-MoveRequestStatistics John.Doe@example.com
    get-mailbox John.Doe@example.com | New-MoveRequest -TargetDatabase EXBD01
    Get-MoveRequest 
    
#endregion

#region mailbox database
New-mailboxDatabase -name "Marketing" -EdbFilePath e:\Marketing\marketing.edb -server EX01 #This creates the database but does not mount it
Mount-Database -Identity Marketing
Get-MailboxDatabase #this will show the different mailboxes
Move-DatabasePath -Identity "Marketing" -EdbFilePath c:\marketing\marketing.edb -LogFolderPath c:\marketing
Set-MailboxDatabase -Identity "Marketing" -DeletedItemRetention 20.00:00:00 -CircularLoggingEnabled $true -ProhibitSendQuota 2.2GB #after this dismount and remount the database.
Dismount-Database -Identity "Marketing"
Mount-Database -Identity Marketing


#endregion

#region restart Microsoft Exchange Information Store Service

Restart-Service MSExchangeIS

#endregion

#region Using eseutil

Dismount-Database -Identity "Marketing" 
#show the health of the database
eseutil /mh c:\marketing\marketing.edb
#look for clean shutdown not dirty
eseutil /d c:\marketing\marketing.edb # this does a defrag it might fix a dirty shutdown.
#mount db
Mount-Database -Identity Marketing

#endregion


#region Recipient management
$pw = Read-Host -Prompt "Enter the password" -AsSecureString
Get-Mailbox
New-Mailbox -UserPrincipalName fred.flintstone@mycompany.com -alias "fred.flintstone" -Database "Mining" -Name "Fred.Flintstone" -organizationalunit users -password $pw -Firstname "Fred" -LastName "Flintstone" -Displayname "Fred Flintstone" -ResetPasswordOnNextLogon $true 
$params = @{
    UserPrincipalName = "fred.flintstone@mycompany.com"
    Alias = "Mining"
    Name = "Fred.Flintstone"
    OrganizationalUnit = "Users"
    Password = $pw
    Firstname = "Fred"
    Lastname = "Flintstone"
    Displayname = "Fred Flintstone"
    ResetPasswordOnNextLogon = $true

}
New-mailbox @params

# create shared mailbox and add user ### check this next bit created by chatgpt----------------------------------------------
New-Mailbox -Shared -Name "Marketing" -DisplayName "Marketing" -Alias "marketing" -PrimarySmtpAddress "marketing@company.com"
# assign full access permission to john and jane
Add-MailboxPermission -Identity "marketing@company.com" -User "john.doe@company.com" -AccessRights FullAccess -InheritanceType All
Add-MailboxPermission -Identity "marketing@company.com" -User "jane.dear@company.com" -AccessRights FullAccess -InheritanceType All
# assign send-as permission to john and jane
Add-ADPermission -Identity "marketing@company.com" -User "john.doe@company.com" -ExtendedRights "Send As"
Add-ADPermission -Identity "marketing@company.com" -User "jane.dear@company.com" -ExtendedRights "Send As"
# check fullaccess permission
Get-MailboxPermission -Identity "marketing@company.com" | Where-Object { $_.User -like "john.doe@company.com" }
Get-MailboxPermission -Identity "marketing@company.com" | Where-Object { $_.User -like "jane.dear@company.com" }
# check send as permission
Get-ADPermission -Identity "marketing@company.com" | Where-Object { $_.User -like "john.doe@company.com" -and $_.ExtendedRights -like "Send As" }
Get-ADPermission -Identity "marketing@company.com" | Where-Object { $_.User -like "jane.dear@company.com" -and $_.ExtendedRights -like "Send As" }
# ----------------------------------------------------------------------------------------------------------------------------

# Create Room mailbox
new-Mailbox -name Room2 -Displayname "Room 2" -Room
# Create Equipment mailbox
New-Mailbox -name Projector2 -Displayname "Projector 2" -Equipment

Set-Mailbox
Enable-Mailbox
Remove-Mailbox

#endregion