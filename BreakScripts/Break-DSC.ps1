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

#region resources

Get-DscResource #Shows resources currently installed

<# 
ImplementedAs   Name                      ModuleName                     Version    Properties                              
-------------   ----                      ----------                     -------    ----------                              
Binary          File                                                                {DestinationPath, Attributes, Checksu...
Binary          SignatureValidation                                                 {SignedItemType, TrustedStorePath}      
PowerShell      PackageManagement         PackageManagement              1.0.0.1    {Name, AdditionalParameters, DependsO...
PowerShell      PackageManagement         PackageManagement              1.4.7      {Name, AdditionalParameters, DependsO...
PowerShell      PackageManagementSource   PackageManagement              1.4.7      {Name, ProviderName, SourceLocation, ...
PowerShell      PackageManagementSource   PackageManagement              1.0.0.1    {Name, ProviderName, SourceUri, Depen...
PowerShell      Archive                   PSDesiredStateConfiguration    1.1        {Destination, Path, Checksum, Credent...
PowerShell      Environment               PSDesiredStateConfiguration    1.1        {Name, DependsOn, Ensure, Path...}      
PowerShell      Group                     PSDesiredStateConfiguration    1.1        {GroupName, Credential, DependsOn, De...
Composite       GroupSet                  PSDesiredStateConfiguration    1.1        {DependsOn, PsDscRunAsCredential, Gro...
Binary          Log                       PSDesiredStateConfiguration    1.1        {Message, DependsOn, PsDscRunAsCreden...
PowerShell      Package                   PSDesiredStateConfiguration    1.1        {Name, Path, ProductId, Arguments...}   
Composite       ProcessSet                PSDesiredStateConfiguration    1.1        {DependsOn, PsDscRunAsCredential, Pat...
PowerShell      Registry                  PSDesiredStateConfiguration    1.1        {Key, ValueName, DependsOn, Ensure...}  
PowerShell      Script                    PSDesiredStateConfiguration    1.1        {GetScript, SetScript, TestScript, Cr...
PowerShell      Service                   PSDesiredStateConfiguration    1.1        {Name, BuiltInAccount, Credential, De...
Composite       ServiceSet                PSDesiredStateConfiguration    1.1        {DependsOn, PsDscRunAsCredential, Nam...
PowerShell      User                      PSDesiredStateConfiguration    1.1        {UserName, DependsOn, Description, Di...
PowerShell      WaitForAll                PSDesiredStateConfiguration    1.1        {NodeName, ResourceName, DependsOn, P...
PowerShell      WaitForAny                PSDesiredStateConfiguration    1.1        {NodeName, ResourceName, DependsOn, P...
PowerShell      WaitForSome               PSDesiredStateConfiguration    1.1        {NodeCount, NodeName, ResourceName, D...
PowerShell      WindowsFeature            PSDesiredStateConfiguration    1.1        {Name, Credential, DependsOn, Ensure...}
Composite       WindowsFeatureSet         PSDesiredStateConfiguration    1.1        {DependsOn, PsDscRunAsCredential, Nam...
PowerShell      WindowsOptionalFeature    PSDesiredStateConfiguration    1.1        {Name, DependsOn, Ensure, LogLevel...}  
Composite       WindowsOptionalFeatureSet PSDesiredStateConfiguration    1.1        {DependsOn, PsDscRunAsCredential, Nam...
PowerShell      WindowsPackageCab         PSDesiredStateConfiguration    1.1        {Ensure, Name, SourcePath, DependsOn...}
PowerShell      WindowsProcess            PSDesiredStateConfiguration    1.1        {Arguments, Path, Credential, Depends...
#>

Find-DscResource jeaRoleCapabilities #finds roles on the gallery.

<#
Name                                Version    ModuleName                          Repository                               
----                                -------    ----------                          ----------                               
JeaRoleCapabilities                 0.7.2      JeaDsc                              PSGallery          
#>


Get-DscResource file -Syntax # shows the syntax for the file resource

<#
File [String] #ResourceName
{
    DestinationPath = [string]
    [Attributes = [string[]]{ Archive | Hidden | ReadOnly | System }]
    [Checksum = [string]{ CreatedDate | ModifiedDate | SHA-1 | SHA-256 | SHA-512 }]
    [Contents = [string]]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [Force = [bool]]
    [MatchSource = [bool]]
    [PsDscRunAsCredential = [PSCredential]]
    [Recurse = [bool]]
    [SourcePath = [string]]
    [Type = [string]{ Directory | File }]
}
#>

#endregion

#region Writing DSC Scripts

Configuration FileServerConfig{
    Node @('LonSVR1','LonDc1'){
        WindowsFeature FileServer {
            Name = 'FS-FileServer'
            Ensure = 'Present'
        }
        WindowsFeature DataDedup {
            Name = 'FS-Data-Deduplication'
            Ensure = 'Present'
        }
    }
}

FileServerConfig -OutputPath c:\dsc 

#Get-DscResource -Name Windowsfeature -Syntax
<#
Get-DscResource -Name Windowsfeature -Syntax
WindowsFeature [String] #ResourceName
{
    Name = [string]
    [Credential = [PSCredential]]
    [DependsOn = [string[]]]
    [Ensure = [string]{ Absent | Present }]
    [IncludeAllSubFeature = [bool]]
    [LogPath = [string]]
    [PsDscRunAsCredential = [PSCredential]]
    [Source = [string]]
}
#>

#endregion















