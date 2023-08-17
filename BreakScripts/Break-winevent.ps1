Break;

Get-WinEvent -FilterHashtable @{
    ProviderName = 'Microsoft-Windows-Kernel-General'
    LogName = 'System'
    Id = 1
} -MaxEvents 30 

<#  PROVIDER NAMES

Microsoft-Windows-Kernel-Cache
Microsoft-Windows-SMBClient
Microsoft-Windows-Ntfs
Microsoft-Windows-UniversalTelemetryClient
Microsoft-Windows-Store
Microsoft-Windows-AppModel-Runtime
Microsoft-Windows-PowerShell
PowerShell
Microsoft-Windows-LAPS
Microsoft-Windows-LiveId
Microsoft-Windows-DSC
Microsoft-Windows-KnownFolders
Microsoft-Windows-WMI-Activity
Microsoft-Windows-Diagnosis-DPS
Microsoft-Windows-Resource-Exhaustion-Resolver
Windows Error Reporting
Microsoft-Windows-WER-PayloadHealth
Microsoft-Windows-Security-Auditing
Microsoft-Windows-Crypto-NCrypt
Microsoft-Windows-Resource-Exhaustion-Detector
Microsoft-Windows-PushNotifications-Platform
Microsoft-Client-Licensing-Platform
Microsoft-Windows-Security-SPP
Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider
Microsoft-Windows-Kernel-EventTracing
Microsoft-Windows-User Device Registration
Microsoft-Windows-Windows Defender
Microsoft-Windows-Audio
Microsoft-Windows-GroupPolicy
Microsoft-Windows-Windows Firewall With Advanced Security
Microsoft-Windows-Application-Experience
Microsoft-Windows-StorPort
Microsoft-Windows-StateRepository
Microsoft-Windows-Kernel-General
Microsoft-Windows-Security-LessPrivilegedAppContainer
Microsoft Office 16 Alerts
EventLog
Microsoft-Windows-TaskScheduler
gupdate
Microsoft-Windows-AAD
Microsoft-Windows-Search
Microsoft-Windows-CoreSystem-SmsRouter
Microsoft-Windows-DeviceManagement-Pushrouter
Microsoft-Windows-DeviceGuard
Microsoft-Windows-SENSE
Microsoft-Windows-BrokerInfrastructure
Microsoft-Windows-DistributedCOM
Service Control Manager
Microsoft-Windows-Bits-Client
Microsoft-Windows-WinRM
VSS
Microsoft-Windows-Storsvc
SecurityCenter
Microsoft-Windows-WindowsUpdateClient
edgeupdate
Microsoft-Windows-Biometrics
Microsoft-Windows-StorageManagement-WSP-Host
Microsoft-Windows-StorageManagement-WSP-Spaces
Microsoft-Windows-StorageManagement
Microsoft-Windows-Time-Service
MsiInstaller
Microsoft-Windows-PrintService
Microsoft-Windows-RestartManager
Windows-ApplicationModel-Store-SDK
Microsoft-Windows-Immersive-Shell
Microsoft-Windows-Security-SPP-UX-Notifications
Microsoft-Windows-NetworkProfile
Microsoft-Windows-DNS-Client
Microsoft-Windows-NCSI
Microsoft-Windows-SMBServer
Microsoft-Windows-WFP
Microsoft-Windows-CloudStore
Microsoft-Windows-AppxPackagingOM
Microsoft-Windows-AppID
Microsoft-Windows-Install-Agent
Microsoft-Windows-Shell-Core
Microsoft Office
Microsoft-Windows-Program-Compatibility-Assistant
Microsoft-Windows-Push-To-Install-Service
Microsoft-Windows-LanguagePackSetup
Microsoft-Windows-Kernel-PnP
Microsoft-Windows-DeviceSetupManager
Microsoft-Windows-Kernel-ShimEngine
Microsoft-Windows-WPD-MTPClassDriver
Microsoft-Windows-UserPnp
Microsoft-Windows-DriverFrameworks-UserMode
Microsoft-Windows-WPDClassInstaller
Microsoft-Windows-AppXDeployment-Server
Microsoft-Windows-CodeIntegrity
ESENT
Microsoft-Windows-Provisioning-Diagnostics-Provider
Microsoft-Windows-ReadyBoost
Microsoft-Windows-AppReadiness
Microsoft-Windows-SmartCard-DeviceEnum
Microsoft-Windows-AppXDeployment
SensorFramework-LogonTask-{100ee514-48c8-f419-6760-6fb8cb2767cd}
Microsoft-Windows-HelloForBusiness
Microsoft-Windows-Crypto-DPAPI
Microsoft-Windows-Wcmsvc
Microsoft-Windows-Winlogon
Microsoft-Windows-TerminalServices-LocalSessionManager
Microsoft-Windows-User Profiles Service
Microsoft-Windows-ModernDeployment-Diagnostics-Provider
Microsoft-Windows-Perflib
Microsoft-Windows-HttpService
Virtual Disk Service
Microsoft-Windows-Servicing
Microsoft-Windows-WinREAgent
Microsoft-Windows-Diagnostics-Performance
Microsoft-Windows-AppXDeployment-Server-UndockedDeh
Microsoft-Windows-TPM-WMI
Microsoft-Windows-WMI
TPM
Microsoft-Windows-MSDTC 2
Microsoft-Windows-Complus
Desktop Window Manager
Microsoft-Windows-WebAuthN
Microsoft-Windows-Containers-BindFlt
Microsoft-Windows-FilterManager
Microsoft-Windows-Containers-Wcifs
Microsoft-Windows-DHCPv6-Client
Microsoft-Windows-Dhcp-Client
Microsoft-Windows-Directory-Services-SAM
LsaSrv
Microsoft-Windows-Wininit
Application Popup
Microsoft-Windows-Kernel-Dump
Microsoft-Windows-Kernel-Processor-Power
Microsoft-Windows-Kernel-WHEA
Microsoft-Windows-VolumeSnapshot-Driver
Microsoft-Windows-Partition
Microsoft-Windows-StorageSpaces-Driver
Microsoft-Windows-Kernel-Boot
Microsoft-Windows-Kernel-Power
Microsoft-Windows-Eventlog
Microsoft-Windows-MSDTC
User32
Microsoft-Windows-TerminalServices-ClientActiveXCore
Microsoft-Windows-Defrag
.NET Runtime Optimization Service
Microsoft-Windows-CertificateServicesClient-Lifecycle-System
Microsoft-Windows-CertificateServicesClient-AutoEnrollment
PowerShellCore
Microsoft-Windows-TZSync
Microsoft-Windows-Diagnosis-Scheduled
Microsoft-Windows-Diagnosis-Scripted
Microsoft-Windows-CloudRestoreLauncher
Microsoft-Windows-Power-Troubleshooter
Microsoft Intune Management Extension
Microsoft-Windows-WindowsSystemAssessmentTool
Microsoft-Windows-NcdAutoSetup
OneDriveUpdaterService
Microsoft-Windows-HttpEvent
Microsoft-Windows-Security-Mitigations
Outlook
Microsoft-Windows-CAPI2
Microsoft-Windows-EventSystem
disk
Microsoft-Windows-Privacy-Auditing
Microsoft-Windows-AppModel-Exec
Microsoft-Windows-EnhancedPhishingProtection-Events
Microsoft-Windows-ShellCommon-StartLayoutPopulation
Microsoft-Windows-Privacy-Auditing-DiagnosticData
Microsoft-Windows-Privacy-Auditing-CPSS
Microsoft-Windows-Privacy-Auditing-TailoredExperiences
Microsoft-Windows-WinINet-Config
Microsoft-Windows-Search-ProfileNotify
Chrome
Microsoft-Windows-Win32k
Microsoft-Windows-Forwarding
System Restore
Microsoft-Windows-RemoteAssistance
Microsoft-Windows-AppLocker
Microsoft-Windows-UserModePowerService
Microsoft-Windows-MUI
Microsoft-Windows-WER-Diag
Microsoft-Windows-Shell-AuthUI
Microsoft-Windows-BitLocker-Driver
Microsoft-Windows-ResetEng
Microsoft-Windows-BitLocker-API
Microsoft-Windows-Setup
Workstation
Microsoft-Windows-SetupPlatform

#>

<# LOGNAMES
Microsoft-Windows-Kernel-Cache/Operational
Microsoft-Windows-PushNotification-Platform/Operational
Windows PowerShell
Microsoft-Windows-PowerShell/Operational
Microsoft-Windows-SmbClient/Connectivity
Microsoft-Windows-Ntfs/Operational
Microsoft-Windows-UniversalTelemetryClient/Operational
Microsoft-Windows-Store/Operational
Microsoft-Windows-AppModel-Runtime/Admin
Microsoft-Windows-LAPS/Operational
Microsoft-Windows-LiveId/Operational
Microsoft-Windows-DSC/Operational
Microsoft-Windows-Known Folders API Service
Microsoft-Windows-WMI-Activity/Operational
Microsoft-Windows-Diagnosis-DPS/Operational
Microsoft-Windows-Resource-Exhaustion-Resolver/Operational
Application
Microsoft-Windows-WER-PayloadHealth/Operational
Security
Microsoft-Windows-Crypto-NCrypt/Operational
Microsoft-Windows-Resource-Exhaustion-Detector/Operational
Microsoft-Client-Licensing-Platform/Admin
Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider/Operational
Microsoft-Windows-Kernel-EventTracing/Admin
Microsoft-Windows-User Device Registration/Admin
Microsoft-Windows-Windows Defender/Operational
Microsoft-Windows-Audio/PlaybackManager
Microsoft-Windows-GroupPolicy/Operational
Microsoft-Windows-Windows Firewall With Advanced Security/Firewall
Microsoft-Windows-Application-Experience/Program-Telemetry
Microsoft-Windows-Storage-Storport/Operational
Microsoft-Windows-StateRepository/Operational
System
Microsoft-Windows-Security-LessPrivilegedAppContainer/Operational
OAlerts
Microsoft-Windows-TaskScheduler/Maintenance
Microsoft-Windows-AAD/Operational
Microsoft-Windows-CoreSystem-SmsRouter-Events/Operational
Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider/Admin
Microsoft-Windows-DeviceGuard/Operational
Microsoft-Windows-SENSE/Operational
Microsoft-Windows-BackgroundTaskInfrastructure/Operational
Microsoft-Windows-Bits-Client/Operational
Microsoft-Windows-WinRM/Operational
Microsoft-Windows-Storsvc/Diagnostic
Microsoft-Windows-WindowsUpdateClient/Operational
Microsoft-Windows-Storage-Storport/Health
Microsoft-Windows-Biometrics/Operational
Microsoft-Windows-StorageManagement/Operational
Microsoft-Windows-Time-Service/Operational
Microsoft-Windows-PrintService/Admin
Microsoft-Windows-TWinUI/Operational
Microsoft-Windows-Security-SPP-UX-Notifications/ActionCenter
Microsoft-Windows-NetworkProfile/Operational
Microsoft-Windows-NCSI/Operational
Microsoft-Windows-SMBServer/Operational
Microsoft-Windows-WFP/Operational
Microsoft-Windows-SmbClient/Security
Microsoft-Windows-CloudStore/Operational
Microsoft-Windows-AppxPackaging/Operational
Microsoft-Windows-AppID/Operational
Microsoft-Windows-Shell-Core/Operational
Microsoft-Windows-Application-Experience/Program-Compatibility-Assistant
Microsoft-Windows-LanguagePackSetup/Operational
Microsoft-Windows-Kernel-PnP/Device Management
Microsoft-Windows-DeviceSetupManager/Admin
Microsoft-Windows-Kernel-ShimEngine/Operational
Microsoft-Windows-DeviceSetupManager/Operational
Microsoft-Windows-Kernel-PnP/Configuration
Microsoft-Windows-Kernel-PnP/Driver Watchdog
Microsoft-Windows-WPD-MTPClassDriver/Operational
Microsoft-Windows-UserPnp/DeviceInstall
Microsoft-Windows-AppXDeploymentServer/Operational
Microsoft-Windows-CodeIntegrity/Operational
Microsoft-Windows-Shell-Core/AppDefaults
Microsoft-Windows-Provisioning-Diagnostics-Provider/Admin
Microsoft-Windows-ReadyBoost/Operational
Microsoft-Windows-AppReadiness/Operational
Microsoft-Windows-AppReadiness/Admin
Microsoft-Windows-AppXDeploymentServer/Restricted
Microsoft-Windows-SmartCard-DeviceEnum/Operational
Microsoft-Windows-AppXDeployment/Operational
Microsoft-Windows-CloudStore/Initialization
Microsoft-Windows-HelloForBusiness/Operational
Microsoft-Windows-Crypto-DPAPI/Operational
Microsoft-Windows-Wcmsvc/Operational
Microsoft-Windows-Winlogon/Operational
Microsoft-Windows-TerminalServices-LocalSessionManager/Operational
Microsoft-Windows-User Profile Service/Operational
Microsoft-Windows-ModernDeployment-Diagnostics-Provider/Autopilot
Microsoft-Windows-ModernDeployment-Diagnostics-Provider/ManagementService
Microsoft-Windows-Perflib/Operational
Setup
Microsoft-Windows-Diagnostics-Performance/Operational
Microsoft-Windows-AppXDeployment-Server/Operational
Microsoft-Windows-WebAuthN/Operational
Microsoft-Windows-Containers-BindFlt/Operational
Microsoft-Windows-Containers-Wcifs/Operational
Microsoft-Windows-Kernel-Dump/Operational
Microsoft-Windows-Kernel-WHEA/Operational
Microsoft-Windows-VolumeSnapshot-Driver/Operational
Microsoft-Windows-Partition/Diagnostic
Microsoft-Windows-StorageSpaces-Driver/Operational
Microsoft-Windows-Ntfs/WHC
Microsoft-Windows-TerminalServices-RDPClient/Operational
Microsoft-Windows-Windows Firewall With Advanced Security/FirewallDiagnostics
Microsoft-Windows-CertificateServicesClient-Lifecycle-System/Operational
PowerShellCore/Operational
Microsoft-Windows-TZSync/Operational
Microsoft-Windows-Diagnosis-Scheduled/Operational
Microsoft-Windows-Diagnosis-Scripted/Operational
Microsoft-Windows-Diagnosis-Scripted/Admin
Microsoft-Windows-CloudRestoreLauncher/Operational
Microsoft-Windows-WindowsSystemAssessmentTool/Operational
Microsoft-Windows-NcdAutoSetup/Operational
Microsoft-Windows-Security-Mitigations/KernelMode
Microsoft-Windows-Kernel-Boot/Operational
Microsoft-Windows-Privacy-Auditing/Operational
Microsoft-Windows-ShellCommon-StartLayoutPopulation/Operational
Microsoft-Windows-WinINet-Config/ProxyConfigChanged
Microsoft-Windows-Win32k/Operational
Microsoft-Windows-Forwarding/Operational
Microsoft-Windows-RemoteAssistance/Operational
Microsoft-Windows-AppLocker/EXE and DLL
Microsoft-Windows-MUI/Operational
Microsoft-Windows-WER-Diag/Operational
Microsoft-Windows-AppLocker/MSI and Script
Microsoft-Windows-Authentication User Interface/Operational
Microsoft-Windows-Audio/Operational
Microsoft-Windows-Dhcp-Client/Admin
Microsoft-Windows-BitLocker/BitLocker Management
#>
