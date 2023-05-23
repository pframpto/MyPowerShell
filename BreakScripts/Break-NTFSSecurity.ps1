break;

#NTFSSecurity 

#Install-Module ntfssecurity
Import-Module NTFSSecurity

#region Commands I have used
    Add-NTFSAccess
    Clear-NTFSAccess
    Disable-NTFSAccessInheritance
    Get-NTFSAccess
    Get-NTFSInheritance
    Get-NTFSSecurityDescriptor # isfile
    Get-NTFSOwner
    Remove-NTFSAccess
    Set-NTFSOwner

#endregion


#region Add-NtfsAccess
Add-NTFSAccess -Path C:\temp\FolderUnderTemp -Account paul -AccessRights FullControl 
Add-NTFSAccess -Path C:\temp\FolderUnderTemp -Account paul -AccessRights FullControl -AccessType Allow -InheritanceFlags ContainerInherit,ObjectInherit

#endregion

#region Clear-NtfsAccess

Clear-NTFSAccess C:\temp\FolderUnderTemp -DisableInheritance

#endregion

#region
Disable-NTFSAccessInheritance -Path C:\temp\FolderUnderTemp -RemoveInheritedAccessRules 
    #This removes inheritance and remove all of the access rules.
Disable-NTFSAccessInheritance -Path C:\temp\FolderUnderTemp
    #This just removes the inheritance
#endregion

#region
Get-NTFSAccess -Path C:\temp\FolderUnderTemp #gets all the access rules
Get-NTFSAccess -Path C:\temp\FolderUnderTemp -Account paul #gets just the access for paul
Get-NTFSAccess -Path C:\temp\FolderUnderTemp | where {$_.Account -like "mycompany\*"} # gets all of the mycompany domain accounts.
Get-NTFSAccess -Path C:\temp\FolderUnderTemp | where {$_.InheritedFrom -eq ""}
Get-NTFSAccess -Path C:\temp\FolderUnderTemp | where {$_.IsInherited -eq $false} # There can be times where inherited from can be an unknown parent. In this can this won't work as expected.
#endregion

#region
Get-NTFSInheritance -Path C:\temp\FolderUnderTemp
    <#
    Name            AccessInheritanceEnabled AuditInheritanceEnabled
    ----            ------------------------ -----------------------
    FolderUnderTemp True                     True   
    #>
(Get-NTFSInheritance -Path C:\temp\FolderUnderTemp).AccessInheritanceEnabled #Produces true or false and can be used in a logic statement.

#endregion

#region
Get-NTFSSecurityDescriptor -Path C:\temp\FolderUnderTemp
    <#
    Item               : C:\temp\FolderUnderTemp
    FullName           : C:\temp\FolderUnderTemp
    Name               : FolderUnderTemp
    IsFile             : False
    SecurityDescriptor : System.Security.AccessControl.DirectorySecurity
    #>
(Get-NTFSSecurityDescriptor -Path C:\temp\FolderUnderTemp).IsFile #False
(Get-NTFSSecurityDescriptor -Path C:\temp\RecentFiles.txt).IsFile #True
#endregion

#region Get-NTFSOwner
Get-NTFSOwner -Path C:\temp\FolderUnderTemp | select Owner
(Get-NTFSOwner -Path C:\temp\FolderUnderTemp).Owner.AccountName #Provides the owner by itself
#endregion

#region Remove-NTFSAccess
Remove-NTFSAccess -Path C:\temp\FolderUnderTemp -Account paul -AccessRights FullControl
Get-NTFSAccess -Path C:\temp\FolderUnderTemp -Account paul | Remove-NTFSAccess #This has the advantage of not needing the access rights in advanced.
Get-NTFSAccess -Path C:\temp\FolderUnderTemp | where {$_.IsInherited -eq $false} | Remove-NTFSAccess
#endregion

#region Set-NTFSOwner
Set-NTFSOwner -Path C:\temp\FolderUnderTemp -Account paul

#endregion