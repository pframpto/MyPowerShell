break;

#region AD
Get-ADUser -Identity anabowman -Properties Department,EmailAddress

Get-ADUser -Filter * -Properties *

New-ADUser "Ana Bowman" -Department IT

New-ADGroup -Name FileServerAdmins -GroupScope Global

New-ADComputer -Name LON-CL10 -Path "ou=marketing,dc=adatum,dc=com" -Enabled $true

Test-ComputerSecureChannel -Repair

New-ADOrganizationalUnit -Name Sales -Path "ou=marketing,dc=adatum,dc=com" -ProtectedFromAccidentalDeletion $true

New-ADObject -Name "AnaBowmancontact" -Type contact

#endregion

#region Manage network service settings for Windows devices using PowerShell cmdlets

New-NetIPAddress -IPAddress 192.168.1.10 -InterfaceAlias "Ethernet" -PrefixLength 24 -DefaultGateway 192.168.1.1

Get-NetRoute
<#
ifIndex DestinationPrefix                              NextHop                                  RouteMetric ifMetric PolicyStore
------- -----------------                              -------                                  ----------- -------- -----------
8       255.255.255.255/32                             0.0.0.0                                          256 15       ActiveStore
1       255.255.255.255/32                             0.0.0.0                                          256 75       ActiveStore
8       224.0.0.0/4                                    0.0.0.0                                          256 15       ActiveStore
1       224.0.0.0/4                                    0.0.0.0                                          256 75       ActiveStore
1       127.255.255.255/32                             0.0.0.0                                          256 75       ActiveStore
1       127.0.0.1/32                                   0.0.0.0                                          256 75       ActiveStore
1       127.0.0.0/8                                    0.0.0.0                                          256 75       ActiveStore
8       10.211.55.255/32                               0.0.0.0                                          256 15       ActiveStore
8       10.211.55.3/32                                 0.0.0.0                                          256 15       ActiveStore
8       10.211.55.0/24                                 0.0.0.0                                          256 15       ActiveStore
8       0.0.0.0/0                                      10.211.55.1                                        0 15       ActiveStore
8       ff00::/8                                       ::                                               256 15       ActiveStore
1       ff00::/8                                       ::                                               256 75       ActiveStore
8       fe80::d07e:e38b:4ec9:a16a/128                  ::                                               256 15       ActiveStore
8       fe80::/64                                      ::                                               256 15       ActiveStore
8       fdb2:2c26:f4e4:0:ab5e:529b:610a:a33d/128       ::                                               256 15       ActiveStore
8       fdb2:2c26:f4e4:0:81c2:4319:a7a9:b7a2/128       ::                                               256 15       ActiveStore
8       fdb2:2c26:f4e4::/64                            ::                                               256 15       ActiveStore
1       ::1/128                                        ::                                               256 75       ActiveStore
8       ::/0                                           fe80::21c:42ff:fe00:18                           256 15       ActiveStore


#>

New-NetRoute -DestinationPrefix 0.0.0.0/24 -InterfaceAlias "Ethernet" -DefaultGateway 192.168.1.1

<#
Cmdlet	Description
Get-DnsClient	Gets details about a network interface
Set-DnsClient	Sets DNS client configuration settings for a network interface
Get-DnsClientServerAddress	Gets the DNS server address settings for a network interface
Set-DnsClientServerAddress	Sets the DNS server address for a network interface

#>
Get-DnsClient
Get-DnsClientServerAddress

Set-DnsClient -InterfaceAlias Ethernet -ConnectionSpecificSuffix "adatum.com"

<#
Cmdlet	Description
New-NetFirewallRule	Creates a new firewall rule
Set-NetFirewallRule	Sets properties for a firewall rule
Get-NetFirewallRule	Gets properties for a firewall rule
Remove-NetFirewallRule	Deletes a firewall rule
Rename-NetFirewallRule	Renames a firewall rule
Copy-NetFirewallRule	Makes a copy of a firewall rule
Enable-NetFirewallRule	Enables a firewall rule
Disable-NetFirewallRule	Disables a firewall rule
Get-NetFirewallProfile	Gets properties for a firewall profile
Set-NetFirewallProfile	Sets properties for a firewall profile
#>

Enable-NetFirewallRule -DisplayGroup "Remote Access"

Set-NetFirewallRule -DisplayGroup "Remote Access" -Enabled True

#endregion

#region Manage Windows Server settings using PowerShell cmdlets

#Cmdlets for managing GPOs
<#
Cmdlet	Description
New-GPO	Creates a new GPO
Get-GPO	Retrieves a GPO
Set-GPO	Modifies properties of a GPO
Remove-GPO	Deletes a GPO
Rename-GPO	Renames a GPO
Backup-GPO	Backs up one or more GPOs in a domain
Copy-GPO	Copies a GPO from one domain to another domain
Restore-GPO	Restores a GPO from backup files
New-GPLink	Links a GPO to an AD DS container
Import-GPO	Imports GPO settings from a backed-up GPO
Set-GPRegistryValue	Configures one or more registry-based policy settings in a GPO
#>

New-GPO -Name "IT Team GPO" -StarterGPOName "IT Starter GPO"

New-GPLink -Name "IT Team GPO" -Target "OU=IT,DC=adatum,DC=com"

#Server management cmdlets
<#
Cmdlet	Description
Get-WindowsFeature	Obtains and displays information about Windows Server roles, services, and features that are installed or are available for installation
Install-WindowsFeature	Installs one or more roles, services, or features
Uninstall-WindowsFeature	Uninstalls one or more roles, services, or features
#>

Install-WindowsFeature "nlb"

#Cmdlets for managing Hyper-V VMs
<#
Cmdlet	Description
Get-VM	Gets properties of a VM
Set-VM	Sets properties of a VM
New-VM	Creates a new VM
Start-VM	Starts a VM
Stop-VM	Stops a VM
Restart-VM	Restarts a VM
Suspend-VM	Pauses a VM
Resume-VM	Resumes a paused VM
Import-VM	Imports a VM from a file
Export-VM	Exports a VM to a file
Checkpoint-VM	Creates a checkpoint of a VM
#>

#IIS and web application administration cmdlets
<#
Cmdlet	Description
New-IISSite	Creates a new IIS website
Get-IISSite	Gets properties and configuration information about an IIS website
Start-IISSite	Starts an existing IIS website on the IIS server
Stop-IISSite	Stops an IIS website
New-WebApplication	Creates a new web application
Remove-WebApplication	Deletes a web application
New-WebAppPool	Creates a new web application pool
Restart-WebAppPool	Restarts a web application pool
#>

#endregion


#region Manage Windows 10 using PowerShell
Get-command -module Microsoft.PowerShell.Management
<#

CommandType     Name                                               Version    Source                                                                                                                                           
-----------     ----                                               -------    ------                                                                                                                                           
Cmdlet          Add-Computer                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Add-Content                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Checkpoint-Computer                                3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Clear-Content                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Clear-EventLog                                     3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Clear-Item                                         3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Clear-ItemProperty                                 3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Clear-RecycleBin                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Complete-Transaction                               3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Convert-Path                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Copy-Item                                          3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Copy-ItemProperty                                  3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Debug-Process                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Disable-ComputerRestore                            3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Enable-ComputerRestore                             3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-ChildItem                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-Clipboard                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-ComputerInfo                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-ComputerRestorePoint                           3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-Content                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-ControlPanelItem                               3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-EventLog                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-HotFix                                         3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-Item                                           3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-ItemProperty                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-ItemPropertyValue                              3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-Location                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-Process                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-PSDrive                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-PSProvider                                     3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-Service                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-TimeZone                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-Transaction                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-WmiObject                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Invoke-Item                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Invoke-WmiMethod                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Join-Path                                          3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Limit-EventLog                                     3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Move-Item                                          3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Move-ItemProperty                                  3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          New-EventLog                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          New-Item                                           3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          New-ItemProperty                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          New-PSDrive                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          New-Service                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          New-WebServiceProxy                                3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Pop-Location                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Push-Location                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Register-WmiEvent                                  3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Remove-Computer                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Remove-EventLog                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Remove-Item                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Remove-ItemProperty                                3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Remove-PSDrive                                     3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Remove-WmiObject                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Rename-Computer                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Rename-Item                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Rename-ItemProperty                                3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Reset-ComputerMachinePassword                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Resolve-Path                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Restart-Computer                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Restart-Service                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Restore-Computer                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Resume-Service                                     3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-Clipboard                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-Content                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-Item                                           3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-ItemProperty                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-Location                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-Service                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-TimeZone                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-WmiInstance                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Show-ControlPanelItem                              3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Show-EventLog                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Split-Path                                         3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Start-Process                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Start-Service                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Start-Transaction                                  3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Stop-Computer                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Stop-Process                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Stop-Service                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Suspend-Service                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Test-ComputerSecureChannel                         3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Test-Connection                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Test-Path                                          3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Undo-Transaction                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Use-Transaction                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Wait-Process                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Write-EventLog                                     3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
#>
#Cmdlets included in the Microsoft.PowerShell.Management module
<#
Cmdlet	Description
Get-ComputerInfo	Retrieves all system and operating system properties from the computer
Get-Service	Retrieves a list of all services on the computer
Get-EventLog	Retrieves events and event logs from local and remote computers (only available in Windows PowerShell 5.1)
Get-Process	Retrieves a list of all active processes on a local or remote computer
Stop-Service	Stops one or more running services
Stop-Process	Stops one or more running processes
Stop-Computer	Shuts down local and remote computers
Clear-EventLog	Deletes all of the entries from the specified event logs on the local computer or on remote computers
Clear-RecycleBin	Deletes the content of a computer's recycle bin
Restart-Computer	Restarts the operating system on local and remote computers
Restart-Service	Stops and then starts one or more services
#>

Get-ComputerInfo

Get-EventLog -LogName Application -Newest 5 -EntryType Error

Clear-EventLog -LogName Application

Get-command -module Microsoft.PowerShell.Security
<#
CommandType     Name                                               Version    Source                                                                                                                                           
-----------     ----                                               -------    ------                                                                                                                                           
Cmdlet          ConvertFrom-SecureString                           3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          ConvertTo-SecureString                             3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Get-Acl                                            3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Get-AuthenticodeSignature                          3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Get-CmsMessage                                     3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Get-Credential                                     3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Get-ExecutionPolicy                                3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Get-PfxCertificate                                 3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          New-FileCatalog                                    3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Protect-CmsMessage                                 3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Set-Acl                                            3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Set-AuthenticodeSignature                          3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Set-ExecutionPolicy                                3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Test-FileCatalog                                   3.0.0.0    Microsoft.PowerShell.Security                                                                                                                    
Cmdlet          Unprotect-CmsMessage                               3.0.0.0    Microsoft.PowerShell.Security 
#>
#Cmdlets included in the Microsoft.PowerShell.Security module
<#
Cmdlet	Description
Get-Acl	This cmdlet gets objects that represent the security descriptor of a file or resource. The security descriptor includes the access control lists (ACLs) of the resource. The ACL lists permissions that users and groups have to access the resource.
Set-Acl	This cmdlet changes the security descriptor of a specified item, such as a file, folder, or a registry key, to match the values in a security descriptor that you supply.
#>

Get-Acl -Path C:\temp |Format-List

(Get-Acl -Path C:\temp).Access

(Get-Acl -Path C:\temp).Access|Format-Table IdentityReference, FileSystemRights, AccessControlType, IsInherited

$ACL = Get-Acl -Path C:\Folder1
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule("User1","Modify","Allow")
$ACL.SetAccessRule($AccessRule)
#$ACL.RemoveAccessRule($AccessRule) # this removes the access rule
$ACL | Set-Acl -Path C:\Folder1

#Copying a security descriptor to a new object
Get-Acl -Path C:\Folder1 |Set-ACL -Path C:\Folder2


#endregion












