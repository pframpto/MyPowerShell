Break;
# get exchange module or update it.
Install-Module ExchangeOnlineManagement -AllowClobber -Force
Import-Module ExchangeOnlineManagement

# connect
Connect-ExchangeOnline

#region Global Address list

Get-GlobalAddressList
New-GlobalAddressList -Name "New GAL"
New-GlobalAddressList -Name GAL_AgencyB -RecipientFilter "(RecipientTypeDetails -eq 'UserMailbox') -and (CustomAttribute15 -eq 'AgencyB')"
New-OfflineAddressBook -Name "Contoso Executives OAB" -AddressLists "Default Global Address List","Contoso Executives Address List" -GlobalWebDistributionEnabled $true
Remove-OfflineAddressBook -Name "Contoso Executives OAB"
Set-OfflineAddressBook -Identity "Default Offline Address Book" -VirtualDirectories $null -GlobalWebDistributionEnabled $true

New-AddressList -Name 'Contoso' -IncludedRecipients MailboxUsers -ConditionalCompany contoso
New-AddressListPolicy -Name 'Contoso' -AddressLists "\Contoso" -OfflineAddressBook "OAB_Contoso" -GlobalAddressList "Contoso GAL" -RoomList "Contoso Rooms"
    #assign address book policy to users
    Get-Recipient -Filter '(company -eq "Contoso") -And (recipientDetails -eq "usermailbox")' | Set-Mailbox -AddressBookPolicy contoso
#endregion


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


#region public folders
Disable-MailPublicFolder
Enable-MailPublicFolder
Get-MailPublicFolder
Get-PublicFolder
New-PublicFolder
New-SyncMailPublicFolder
Remove-PublicFolder
Remove-SyncMailPublicFolder
Set-MailPublicFolder
Set-PublicFolder

#endregion

#region client access rules
#https://learn.microsoft.com/en-us/exchange/clients-and-mobile-in-exchange-online/client-access-rules/procedures-for-client-access-rules
New-ClientAccessRule -Name "<RuleName>" [-Priority `<PriorityValue>] [-Enabled <$true | $false>] -Action <AllowAccess | DenyAccess> [<Conditions>] [<Exceptions>]
New-ClientAccessRule -Name "Block ActiveSync" -Action DenyAccess -AnyOfProtocols ExchangeActiveSync -ExceptAnyOfClientIPAddressesOrRanges 192.168.10.1/24
Get-ClientAccessRule -Identity "<RuleName>" | Format-List [<Specific properties to view>]
New-ClientAccessRule -Name "OutlookWebApp" -Action Deny -AnyOfProtocols OutlookWebApp -ExceptAnyOfClientIPAddressesOrRanges 192.168.10.1/24
Test-ClientAccessRule -AuthenticationType basicAuthentication -Protocol OUtlookWebApp -RemoteAddress 10.0.0.1 -RemotePort 443 -User jc@examlabpractice.com
#If there is no reply that means you can connect if you can not connect it says denied with reason.
Remove-ClientAccessRule -Identity "Block ActiveSync"


#endregion

#region message trace
 Get-HistoricalSearch 
 Get-MessageTrace -SenderAddress connector@exclaim-it.com.au -StartDate (Get-Date).AddHours(-24) -EndDate (Get-Date)
 Get-MessageTrace -RecipientAddress me@mydomain.com -StartDate (Get-Date).AddHours(-240) -EndDate (Get-Date)
 start chrome https://testconnectivity.microsoft.com/  #Microsoft Remote Connectivity Analyzer

#endregion