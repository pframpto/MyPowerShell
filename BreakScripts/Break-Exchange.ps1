Break;

get-mailbox

#region Creating a PST
New-MailboxExportRequest -Mailbox Mailbox -FilePath '\\fileserver\psts\Mailbox.pst' 
New-MailboxExportRequest -Mailbox Mailbox -FilePath '\\fileserver\psts\Mailbox.pst' -IsArchive
    
#endregion
    
#region Adding and Removing Distribution Group members
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
Set-MailboxDatabase
Move-DatabasePath -Identity "Marketing" -EdbFilePath c:\marketing\marketing.edb -LogFolderPath c:\marketing

#endregion

#region restart Microsoft Exchange Information Store Service

Restart-Service MSExchangeIS

#endregion