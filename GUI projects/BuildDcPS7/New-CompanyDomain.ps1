function New-CompanyDomain {
    [cmdletbinding()]    
    param(
        [Parameter(Mandatory)]
        [ValidateSet('company.pri','company.com', 'pinkdolphinterritory.com')]
        $DomainName ,
        [Parameter(Mandatory)]
        [ValidateSet('company','pdt', 'pinkdolphinterritory')]
        $DomainNetbiosName,
        [Parameter(Mandatory)]
        $SafeModePword,
        [Parameter(Mandatory)]
        [ValidateSet('Win2012','Win2012R2', 'WinThreshold')]
        $forestmode
        
    )

#region install prereqs

    #From recipe install powershell 7
((Get-WindowsFeature AD-Domain-Services).installed) ? (write-host "Feature is installed" -ForegroundColor green) : 
    (Install-WindowsFeature AD-Domain-Services -IncludeManagementTools )
((get-windowsfeature RSAT-AD-Tools).installed ) ? (write-host "Feature is installed" -ForegroundColor green) : 
    (Install-WindowsFeature RSAT-AD-Tools -includeAllSubFeature)

#endregion#>

    Import-Module ADDSDeployment
    $param = @{'CreateDnsDelegation'=$false;
           'DatabasePath'="C:\Windows\NTDS";
           'DomainName'=$DomainName;
           'DomainNetbiosName'=$DomainNetbiosName;
           'forestmode'=$forestmode;
           'installdns'=$true;
           'logpath'="C:\Windows\NTDS";
           'NoRebootOnCompletion'=$true;           
           'confirm'=$false           
          }

    Install-ADDSForest @param -SafeModeAdministratorPassword (convertTo-SecureString -AsPlainText $SafeModePword -Force )
    
    


}

Invoke-Expression (Show-Command New-CompanyDomain -PassThru ) -ErrorAction Ignore 