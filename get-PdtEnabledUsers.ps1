<#
.SYNOPSIS
   This script finds users that are enabled
.DESCRIPTION
   This script finds users that are enabled and have a user principal name that matches
   first name dot last name @ domain name
   This should exclude disabled users, service accounts and built in security principals.
.EXAMPLE

    Get-PDTEnabledUsers
.EXAMPLE

    Get-PDTEnabledUsers -limit 10

    Returns Fist 10 Enabled Users
.EXAMPLE

    (Get-PDTEnabledUsers -limit 10).UserPrincipalName

    Returns Just the UserPrincipalNames of the first 10 users.
#>
Function Get-PDTEnabledUsers {
    [cmdletbinding()]
    param(
        $limit = 1000000,
        $server = "DC1.company.pri"
    )
    Write-Verbose "Creating C:\temp if it does not already exist"
    if(Test-Path c:\Temp){
        Write-verbose "C:\temp exists"
    }
    else{Mkdir c:\Temp}
    Write-Verbose "Finding users who have a upn that is in the format name.name@ who are enabled."
    Get-ADUser -filter {enabled -eq $true -and UserPrincipalName -like "*.*@*"} -ResultSetSize $limit
}

Get-PDTEnabledUsers -Verbose | Export-csv c:\temp\EnabledUsers.csv  -NoTypeInformation

