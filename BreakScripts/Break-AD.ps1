break;

#region Create User 

$Param = @{
    'Name' = "FirstName.LastName";
    'AccountPassword' = (convertTo-SecureString -AsPlainText "P@ssword" -Force );
    "DisplayName" = "FirstName.LastName";
    'GivenName' = "FirstName";
    'Path' = "OU=CompanyUsers,DC=MyCompany,DC=pri";
    "SamAccountName" = "FirstName.LastName";
    "Surname" = "LastName"
    "Enabled" = $true
}
New-ADUser @param 

#endregion

#region Create Group

New-ADGroup -Name 'GroupName' -GroupScope Global -Path "OU=CompanyUsers,DC=mycompany,DC=pri" 
#endregion

#region Add user to Group

Add-ADGroupMember -Identity GroupName -Members "FirstName.LastName"

#endregion

#region Create OU

New-ADOrganizationalUnit -Name "NewOU" -Path "DC=MyCompany,DC=pri"

#endregion

#region Create Site

New-ADReplicationSite -Description "NSW site sydney office" -Name "NSW"

#endregion

#region Create Subnet


New-ADReplicationSubnet -Name "10.10.2.0/24" -Site QLD -Location "Brisbane,QLD" -Description "The Brisbane Office"

#endregion

#region Create GPO

New-GPO -Name NSWUsers -Comment "GPO for NSW Users"

#endregion

#region Link GPO


new-GPLink -name NSWUsers -Target "OU=NSW,DC=company,DC=pri" -LinkEnabled Yes


#endregion

#region Command names for the GUI tools
    dsa.msc #Active Directory Users and Computers
    servermanager # Server Manager
    domain.msc # AD domains and trusts
    dsac.exe #Active Director Administrative Center
    dssite.msc # Active Directory Sites and Services
    gpedit.msc # local group policy editor
    gpmc.msc # group policy management console
#endregion

#region install AD

Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
$param = @{'CreateDnsDelegation'=$false;
           'DatabasePath'="C:\Windows\NTDS";
           'DomainName'='company.pri';
           'DomainNetbiosName'='company';
           'forestmode'='win2012r2';
           'installdns'=$true;
           'logpath'="C:\Windows\NTDS";
           'NoRebootOnCompletion'=$true;           
           'confirm'=$false           
          }

Install-ADDSForest @param -SafeModeAdministratorPassword (convertTo-SecureString -AsPlainText "P@ssw0rd" -Force )

#endregion