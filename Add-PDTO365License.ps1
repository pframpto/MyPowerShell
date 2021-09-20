<#
.SYNOPSIS
   Adds Office 365 Licenses to selected users
.DESCRIPTION
   Adds Office 365 Licenses to selected users

   This script can be executed on any machine that has the MSOnline module installed.
.EXAMPLE
   Add-PDTO365License -EmailAddress Joe.User@company.com -licenses PDT:STANDARDPACK
.EXAMPLE
   Add-PDTO365License -EmailAddress Joe.User@company.com -licenses PDT:ATP_ENTERPRISE,PDT:FLOW_FREE 
#>
Function Add-DOJO365License {

    [cmdletbinding()]
    param(
        [Parameter(mandatory=$true)]
        [string]$emailaddress,
        [string]$licenses = "PDT:STANDARDPACK"
        
    )

    Begin{    
    Import-Module MSonline    
    }
    Process{    
    Write-Verbose "$licenses"
    Write-Verbose $emailaddress    
    if((Get-MsolUser -UserPrincipalName $emailaddress).islicensed){
        Set-MsolUserLicense -UserPrincipalName $emailaddress -RemoveLicenses $licenses
    }
    if($licenses = "PDT:STANDARDPACK" ){
        $LO = New-MsolLicenseOptions -AccountSkuId $licenses -DisabledPlans  "YAMMER_ENTERPRISE" , "MCOSTANDARD" , "SHAREPOINTSTANDARD" , "SHAREPOINTWAC"
        Set-MsolUser -UsageLocation 'AU' -UserPrincipalName $emailaddress
        Set-MsolUserLicense -UserPrincipalName $emailaddress -LicenseOptions $LO -AddLicenses $licenses -Verbose
        }
    
    else{
        Set-MsolUser -UsageLocation 'AU' -UserPrincipalName $emailaddress
        Set-MsolUserLicense -UserPrincipalName $emailaddress -AddLicenses $licenses -Verbose
        }

    
    }
    End{}
}
$EmailAddress = "sample.user@company.com"
Connect-MsolService
Add-DOJO365License -EmailAddress $emailaddress 

