Return "This is a walk-through demo script file"

#run in the scripting editor

#Create a folder for my configs
if (-Not (Test-Path c:\DSC)) {
    New-Item -ItemType Directory -path C:\ -name DSC
}

#dot source the file
. .\BasicServer.ps1

#run the configuration to generate the MOF
BasicServer -outputpath c:\DSC

#current LCM settings
Get-DscLocalConfigurationManager -CimSession MS

#configure the LCM
Set-DscLocalConfigurationManager -path c:\DSC -verbose
#verify
Get-DscLocalConfigurationManager -CimSession ms

Clear-Host

#start the configuration
Start-DscConfiguration -path c:\DSC -Wait -Verbose -Force -CimSession ms
