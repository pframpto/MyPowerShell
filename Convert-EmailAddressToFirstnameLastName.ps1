<#
.SYNOPSIS
   This script breaks and email address into firstname lastname
.DESCRIPTION
   This script breaks and email address into firstname lastname

   If an emailaddress is in the form firstname.lastname@company.com
   This script will break it up into firstname lastname.
   The script is intended to illustrate a technique for doing this.
   It would need to be modified to serve an actual purpose.
.EXAMPLE
   Convert-EmailAddressToFirstnameLastName -EmailAddress company.user@company.pri

    The firstname is company
    The lastname is user
#>
Function Convert-EmailAddressToFirstnameLastName {
    [cmdletbinding()]
    param(
        [string]$EmailAddress
    )
    $Firstname = $EmailAddress.split(".")[0]
    $lastnameA = $EmailAddress.split(".")[1]
    $lastname = $lastnameA.Split("@")[0]
    Write-Output "The firstname is $Firstname"
    Write-Output "The lastname is $lastname"
}

Convert-EmailAddressToFirstnameLastName -EmailAddress company.user@company.pri