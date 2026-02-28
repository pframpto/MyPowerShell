break;

#region Commands

Disable-DscDebug
Enable-DscDebug
Get-DscConfiguration
Get-DscConfigurationStatus
Get-DscLocalConfigurationManager
Get-DscResource
New-DscChecksum
Remove-DscConfigurationDocument
Restore-DscConfiguration
Stop-DscConfiguration
Invoke-DscResource
Publish-DscConfiguration
Set-DscLocalConfigurationManager
Start-DscConfiguration
Test-DscConfiguration
Update-DscConfiguration

#endregion


#region LCM view

Get-DscLocalConfigurationManager

<# Shows meta setting for LCM

ActionAfterReboot              : ContinueConfiguration
AgentId                        : 168565F2-145F-11F1-9CEF-5802058A11FF
AllowModuleOverWrite           : False
CertificateID                  : 
ConfigurationDownloadManagers  : {}
ConfigurationID                : 
ConfigurationMode              : ApplyAndMonitor
ConfigurationModeFrequencyMins : 15
Credential                     : 
DebugMode                      : {NONE}
DownloadManagerCustomData      : 
DownloadManagerName            : 
LCMCompatibleVersions          : {1.0, 2.0}
LCMState                       : Idle
LCMStateDetail                 : 
LCMVersion                     : 2.0
StatusRetentionTimeInDays      : 10
SignatureValidationPolicy      : NONE
SignatureValidations           : {}
MaximumDownloadSizeMB          : 500
PartialConfigurations          : 
RebootNodeIfNeeded             : False
RefreshFrequencyMins           : 30
RefreshMode                    : PUSH
ReportManagers                 : {}
ResourceModuleManagers         : {}
PSComputerName                 : 

#>

#endregion

#region setting LCM

[DSCLocalConfigurationManager()]
configuration LCMConfig
{
    Node localhost
    {
        Settings{
            ConfigurationMode = 'ApplyAndAutoCorrect'
            ConfigurationModeFrequencyMins = 30
            RefreshMode = 'Push'
        }
    }
}

LCMConfig -outputPath d:\LCMConfigs
Set-DscLocalConfigurationManager -Path d:\LCMConfigs

#endregion