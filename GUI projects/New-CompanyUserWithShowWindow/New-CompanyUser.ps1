function New-CompanyUser {
param(
    [Parameter(Mandatory)]
    $FirstName,
    [Parameter(Mandatory)]
    $LastName,
    [Parameter(Mandatory)]
    $Password,
    [Parameter(Mandatory)]
    [ValidateSet('NSW','QLD', 'VIC')]
    $OU,
    [Switch]$QLDUsersGroup,
    [Switch]$NSWUsersGroup,
    [Switch]$VICUsersGroup
)
    switch ($OU){
        "NSW" {
            $OUDN = "OU=NSW,DC=company,DC=pri"
            $City = "Sydney"
            $State = "NSW"
        }
        "QLD" {
            $OUDN = "OU=QLD,DC=company,DC=pri"
            $City = "Brisbane"
            $State = "QLD"
        }
        "VIC" {
            $OUDN = "OU=VIC,DC=company,DC=pri"
            $City = "Melbourne"
            $State = "VIC"
        }
    }
    
    Write-Verbose $OUDN 
    $Splat = @{
        "City" = $City
        "DisplayName" = "$FirstName.$LastName"
        "Company" = "Company"
        "EmailAddress" = "$FirstName.$LastName@Company.pri"
        "GivenName" = $FirstName
        'HomeDirectory' = "c:\home\$FirstName.$LastName"
        'HomeDrive' = 'H'
        'Path' = $OUDN
        'SamAccountName' = "$FirstName.$LastName"
        "State" = $State
        "Surname" = $LastName
        "Enabled" = $true
        "Country" = "AU"
        "Name" = "$FirstName.$LastName"
        "UserPrincipalName" = "$FirstName.$LastName@Company.pri"
    }
   
  $newUser = New-ADUser  -AccountPassword (convertTo-SecureString -AsPlainText $Password -Force )  @Splat  
     
    # Add user to group
    if($QLDUsersGroup){
        Add-ADGroupMember -Identity QLDUsers -Members $Splat.name
        
    }
    if($NSWUsersGroup){
        Add-ADGroupMember -Identity NSWUsers -Members $Splat.name
    }
    if($VICUsersGroup){
        Add-ADGroupMember -Identity VICUsers -Members $Splat.name
    }
   
}

Invoke-Expression (Show-Command New-CompanyUser -PassThru ) -ErrorAction Ignore

break;

try{
        
}Catch{}