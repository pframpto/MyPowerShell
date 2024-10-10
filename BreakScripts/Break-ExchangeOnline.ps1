Break;

# To create a mailbox licesense the user

        
#region Adding and Removing Distribution Group members
    
    Add-DistributionGroupMember -Identity 'DistributionGroup' -Member memberToAdd
    Remove-DistributionGroupMember -Identity 'DistributionGroup' -Member memberToRemove
                   
#endregion
        
#region Add and Remove Permissions
    
    "Adding Calendar Permission"
    add-MailboxFolderPermission -Identity SharingUser":\calendar" -User ShareeUser -AccessRights owner
    "To view permissions"
    Get-MailboxFolderPermission SharingUser:\calendar 
    "To remove Calendar Permission"
    Remove-MailboxFolderPermission -Identity SharingUser":\calendar" -User ShareeUser
    "Adding public folder permissions"
    Add-PublicFolderClientPermission -Identity "\pubicFolderName" -AccessRights owner -User User
    "Adding Mailbox permissions"
    Add-MailboxPermission SharingUsersMailbox -AccessRights fullaccess,deleteitem -User SharedWithUser -AutoMapping $true
    Remove-MailboxPermission SharingUsersMailbox -AccessRights fullaccess,deleteitem -User SharedWithUser
                
#endregion
        
#region SendAs and SendOnBehalf
                 
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