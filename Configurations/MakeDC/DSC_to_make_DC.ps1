#Install-Module -Name xActiveDirectory


Configuration NewTestEnvironment{  
    Import-DscResource –ModuleName 'PSDesiredStateConfiguration'      
    Import-DscResource -ModuleName xActiveDirectory
    
    
   
    
            
    Node localhost   {
        
        
        WindowsFeature AD-Domain-Services{
            Ensure = 'Present'
            Name = 'AD-Domain-Services'
            IncludeAllSubFeature = $true
            
        }

        WindowsFeature  RSAT-AD-Tools{
            Ensure = 'Present'
            Name =  'RSAT-AD-Tools'
            IncludeAllSubFeature = $true
        }
                    
        
        xADDomain ADDomain{             
            DomainName = "company.pri"
            DomainAdministratorCredential = $localuser 
            SafemodeAdministratorPassword = $SafeModePW
            DependsOn = '[WindowsFeature]AD-Domain-Services'
            DomainNetbiosName = "company"
        }#>

        xADOrganizationalUnit NSW
                {
                    Ensure = 'Present'
                    Name = "NSW"
                    Path = "DC=company,DC=pri"
                    Description = "NSW Users"
                    DependsOn = '[xADDomain]ADDomain'
                }

         xADGroup NSWUsers
                {
                    Ensure = 'Present'
                    GroupName = "NSWUsers"
                    Path = "OU=NSW,DC=company,DC=pri"
                    DependsOn = '[xADOrganizationalUnit]NSW'
                }#>
        xADOrganizationalUnit QLD
                {
                    Ensure = 'Present'
                    Name = "QLD"
                    Path = "DC=company,DC=pri"
                    Description = "QLD Users"
                    DependsOn = '[xADDomain]ADDomain'
                }

         xADGroup QLDUsers
                {
                    Ensure = 'Present'
                    GroupName = "QLDUsers"
                    Path = "OU=QLD,DC=company,DC=pri"
                    DependsOn = '[xADOrganizationalUnit]QLD'
                }#
        xADOrganizationalUnit VIC
                {
                    Ensure = 'Present'
                    Name = "VIC"
                    Path = "DC=company,DC=pri"
                    Description = "VIC Users"
                    DependsOn = '[xADDomain]ADDomain'
                }

         xADGroup VICUsers
                {
                    Ensure = 'Present'
                    GroupName = "VICUsers"
                    Path = "OU=VIC,DC=company,DC=pri"
                    DependsOn = '[xADOrganizationalUnit]VIC'
                }#>

        xADUser Paul{
            DomainName = "company.pri"
            UserName = "Paul"
            DisplayName = "Paul F"
            Description = "My Account I created"
            EmailAddress = "paulf@company.pri"
            Enabled = $true
            GivenName = "Paul"
            OfficePhone = '(07)55555555'
            Password = $localuser
            Path = "OU=QLD,DC=company,DC=pri"
            

        }
    }         
}

$secpasswd = ConvertTo-SecureString 'P@ssw0rd' -AsPlainText -Force
$SafeModePW = New-Object System.Management.Automation.PSCredential ('guest', $secpasswd)


$secpasswd = ConvertTo-SecureString 'P@ssw0rd' -AsPlainText -Force
$localuser = New-Object System.Management.Automation.PSCredential ('guest', $secpasswd)

$configData = @{
                AllNodes = @(
                              @{
                                 NodeName = 'localhost';
                                 PSDscAllowPlainTextPassword = $true
                                    }
                    )
               }



NewTestEnvironment  -OutputPath c:\dsc -ConfigurationData $configData

break;

Start-DscConfiguration -Wait -Force -Path c:\DSC  -Verbose 





<#####################################
PS C:\Users\Administrator\Desktop\MakeDC> Get-DscResource xaddomain -Syntax
xADDomain [String] #ResourceName
{
    DomainAdministratorCredential = [PSCredential]
    DomainName = [string]
    SafemodeAdministratorPassword = [PSCredential]
    [DatabasePath = [string]]
    [DependsOn = [string[]]]
    [DnsDelegationCredential = [PSCredential]]
    [DomainMode = [string]{ Win2008 | Win2008R2 | Win2012 | Win2012R2 | WinThreshold }]
    [DomainNetbiosName = [string]]
    [ForestMode = [string]{ Win2008 | Win2008R2 | Win2012 | Win2012R2 | WinThreshold }]
    [LogPath = [string]]
    [ParentDomainName = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [SysvolPath = [string]]
}

############################################################>