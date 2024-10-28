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
    Get-AddressBookPolicy 
    Get-AddressList
    Get-GlobalAddresslist
    #offline address book
    Get-OfflineAddressBook
    Get-AddressList
    New-OfflineAddressBook -Name "Marketing OAB" -AddressLists "Marketing" 
    Get-OfflineAddressBook "Marketing OAB" | Update-OfflineAddressBook

    #New address book policy
    New-AddressBookPolicy -Name "Test ABP" -AddressLists "\All Contacts","\All Users","\Marketing" `
    -RoomList "\All Rooms" -GlobalAddressList "\Default Global Address List" -OfflineAddressBook "\Default Offline Address Book"

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

#region mailbox policy
New-MobileDeviceMailboxPolicy -Name "Marketing Mobile Control" -PasswordEnabled $true -AlphanumericPasswordRequired $true -PasswordRecoveryEnabled $true -MinPasswordComplexCharacters 3 -IsDefault $false -PasswordHistory 10
 # Mobile >> Mobile device access >> Device Access Rules 
New-ActiveSyncDeviceAccessRule -Characteristic DeviceOS -QueryString "Android 3.0.0" -AccessLevel Block 
#endregion

#region DAGs
New-DatabaseAvailabilityGroup -Name DAG1 -WitnessServer FILESRV1 -WitnessDirectory C:\DAG1
New-DatabaseAvailabilityGroup -Name DAG3 -WitnessServer MBX2 -WitnessDirectory C:\DAG3 -DatabaseAvailabilityGroupIPAddresses 10.0.0.8,192.168.0.8
New-DatabaseAvailabilityGroup -Name DAG5 -DatabaseAvailabilityGroupIPAddresses ([System.Net.IPAddress]::None) -WitnessServer MBX4
Get-DatabaseAvailabilityGroup `<DAGName`> | Format-List

Get-MailboxDatabaseCopyStatus 
Test-ReplicationHealth


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

Get-PublicFolder \marketing -Recurse
New-PublicFolder -Name Finance
New-PublicFolder -Name Reports -Path \Finance

#endregion

#region Virtual Directory

Get-OwaVirtualDirectory | select *ternalUrl
Set-OwaVirtualDirectory # use this to set the internalurl and the externalurl
get-oabvirtualdirectory
get-websericesvirtualdirectory
get-outlookanywhere
get-mapivirtualdirectory
#these can all be piped to the corresponding set command with the correct options for internalurl and externalurl
#endregion

#region client access rules
#https://learn.microsoft.com/en-us/powershell/module/exchange/new-clientaccessrule?view=exchange-ps
Get-clientAccessRule
New-ClientAccessRule -Name AllowRemotePS -Action Allow -AnyOfProtocols RemotePowerShell -Priority 1

#endregion


#region backup and restoration.
Get-mailbox janwilliams@exampractice.com | fl name,database,guid
#save the guid $guid = "f1d7e6f2-8520-432f-a5ef-24cb86a6a6ea"
#setup backup on ex server
#Create a network share to store backup.
#do full server backup backing up to that share.

#restoration
#-----------
#an email has been purged and we want to restore it.
# In windows server backup click recover use share as the backup from
# in recovery type choose application and out of application select exchange select do not perform a roll forward recovery of app dbs.
#      Recover to another location choose a new folder you can call it restore if you want. Then click recover.
# in the EMS
Get-mailboxdatabase -ID "Marketing" | fl name,guid,edbfilepath,logfolderpath
#name : Marketing
#Guid : dbd2ff1c-e6f0-4aa6-b62b-69ad69dfadcb
#EDBfilepath : C:\marketing\marketing.edb
#logfolderpath : C:\marketing
#now we create a recovery db
New-MailboxDatabase -Recovery -Name RecoveryDB -EdbFilePath "C:\restore\dbd2ff1c-e6f0-4aa6-b62b-69ad69dfadcb\C_\marketing\marketing.edb" `
-LogFilePath "C:\restore\dbd2ff1c-e6f0-4aa6-b62b-69ad69dfadcb\C_\marketing\" -Server NYC-EX1 

Restart-Service MSExchangeIS
# now we need to use the eseutil to make sure the database is in a clean shutdown state.
CD "C:\restore\dbd2ff1c-e6f0-4aa6-b62b-69ad69dfadcb\C_\marketing\"
eseutin /r e02 /d 

mount-database RecoveryDB

Get-MailboxStatistics -Database RecoveryDB 

New-MailboxRestoreRequest -SourceDatabase RecoveryDB -SourceStoreMailbox "jan williams" -TargetMailbox janwilliams@exampractice.com 
# it says it is qued use:
Get-MailboxRestoreRequest 
# to check its progress it will say in progress then completed when it is finished.
# now going back to the owa the email deleted at the start has been restored.



#endregion