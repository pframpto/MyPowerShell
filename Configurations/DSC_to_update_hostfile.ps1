
<#PSScriptInfo
.VERSION 1.0.0
.GUID e4536f6b-b2a4-41b6-94eb-4c5e1dccac53
.AUTHOR DSC Community
.COMPANYNAME DSC Community
.COPYRIGHT Copyright the DSC Community contributors. All rights reserved.
.TAGS DSCConfiguration
.LICENSEURI https://github.com/dsccommunity/NetworkingDsc/blob/main/LICENSE
.PROJECTURI https://github.com/dsccommunity/NetworkingDsc
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES First version.
.PRIVATEDATA 2016-Datacenter,2016-Datacenter-Server-Core
#>

#Requires -module NetworkingDsc

<#
    .DESCRIPTION
    Add a new host to the host file.
#>
Configuration HostsFile_AddEntry_Config
{
    Import-DSCResource -ModuleName NetworkingDsc

    Node dc
    {
        HostsFile HostsFileAddEntry
        {
            HostName  = 'Host01'
            IPAddress = '192.168.110.6'
            Ensure    = 'Present'
        }
        HostsFile HostsFileAddEntry2
        {
            HostName  = 'Host02'
            IPAddress = '192.168.110.3'
            Ensure    = 'Present'
        }
    }
}

HostsFile_AddEntry_Config -OutputPath C:\dsc -InstanceName dc

Start-DscConfiguration -Path C:\dsc -Wait -Force -Verbose -ComputerName dc