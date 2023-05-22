break;

# Create User 
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

# Create Group

New-ADGroup -Name 'GroupName' -GroupScope Global -Path "OU=CompanyUsers,DC=mycompany,DC=pri" 


# Add user to Group

Add-ADGroupMember -Identity GroupName -Members "FirstName.LastName"


# Create OU