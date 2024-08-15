break;

#wim and Cim

Get-CimInstance -Namespace root -ClassName __Namespace
#namespaces returned
<#
Name            PSComputerName
----            --------------
subscription                  
DEFAULT                       
CIMV2                         
msdtc                         
Cli                           
SECURITY                      
SecurityCenter2               
RSOP                          
PEH                           
MEM                           
StandardCimv2                 
WMI                           
directory                     
Policy                        
Interop                       
Hardware                      
ServiceModel                  
SecurityCenter                
Microsoft      
#>

Get-CimInstance -Namespace root\cimv2 -ClassName Win32_OperatingSystem | Get-Member



Get-WmiObject -Namespace root -List -Recurse | Select -Unique __NAMESPACE
<#
__NAMESPACE                                                     
-----------                                                     
ROOT                                                            
ROOT\subscription                                               
ROOT\DEFAULT                                                    
ROOT\CIMV2                                                      
ROOT\cimv2                                                      
root\CIMV2                                                      
ROOT\msdtc                                                      
ROOT\Cli                                                        
ROOT\SECURITY                                                   
ROOT\SecurityCenter2                                            
ROOT\RSOP                                                       
ROOT\PEH                                                        
ROOT\MEM                                                        
ROOT\StandardCimv2                                              
ROOT\standardcimv2                                              
ROOT\WMI                                                        
ROOT\directory                                                  
ROOT\Policy                                                     
ROOT\Interop                                                    
ROOT\Hardware                                                   
ROOT\ServiceModel                                               
ROOT\SecurityCenter                                             
ROOT\Microsoft                                                  
ROOT\CIMV2\mdm                                                  
ROOT\CIMV2\Security                                             
ROOT\CIMV2\power                                                
ROOT\CIMV2\TerminalServices                                     
ROOT\RSOP\User                                                  
ROOT\RSOP\Computer                                              
ROOT\Rsop\Computer                                              
ROOT\StandardCimv2\embedded                                     
ROOT\directory\LDAP                                             
ROOT\Microsoft\HomeNet                                          
ROOT\Microsoft\ProtectionManagement                             
ROOT\Microsoft\Windows                                          
ROOT\Microsoft\SecurityClient                                   
ROOT\CIMV2\mdm\dmmap                                            
ROOT\CIMV2\Security\MicrosoftTpm                                
ROOT\CIMV2\Security\MicrosoftVolumeEncryption                   
ROOT\RSOP\User\S_1_12_1_3636430439_1272973603_767312768_71615533
ROOT\Microsoft\Windows\RemoteAccess                             
ROOT\Microsoft\Windows\Dns                                      
ROOT\Microsoft\Windows\Powershellv3                             
ROOT\Microsoft\Windows\DeviceGuard                              
ROOT\Microsoft\Windows\TaskScheduler                            
ROOT\Microsoft\Windows\DesiredStateConfigurationProxy           
ROOT\Microsoft\Windows\SmbWitness                               
ROOT\Microsoft\Windows\Wdac                                     
ROOT\Microsoft\Windows\winrm                                    
ROOT\Microsoft\Windows\AppBackgroundTask                        
ROOT\Microsoft\Windows\PS_MMAgent                               
ROOT\Microsoft\Windows\Storage                                  
ROOT\Microsoft\Windows\HardwareManagement                       
ROOT\Microsoft\Windows\SMB                                      
ROOT\Microsoft\Windows\Smb                                      
ROOT\Microsoft\Windows\EventTracingManagement                   
ROOT\Microsoft\Windows\DesiredStateConfiguration                
ROOT\Microsoft\Windows\CI                                       
ROOT\Microsoft\Windows\DeliveryOptimization                     
ROOT\Microsoft\Windows\Defender                                 
ROOT\Microsoft\Windows\RemoteAccess\Client                      
ROOT\Microsoft\Windows\Storage\PT                               
ROOT\Microsoft\Windows\Storage\Providers_v2                     
ROOT\Microsoft\Windows\Storage\PT\Alt 
#>

#Listing classes

Get-WmiObject -Namespace root\CIMv2 -List

Get-CimClass -Namespace root\CIMV2 


#Finding classes

Get-CimClass *network* | Sort CimClassName
<#
NameSpace: ROOT/cimv2

CimClassName                        CimClassMethods      CimClassProperties                                                                                                                                                    
------------                        ---------------      ------------------                                                                                                                                                    
CIM_NetworkAdapter                  {SetPowerState, R... {Caption, Description, InstallDate, Name...}                                                                                                                          
Win32_NetworkAdapter                {SetPowerState, R... {Caption, Description, InstallDate, Name...}                                                                                                                          
Win32_NetworkAdapterConfiguration   {EnableDHCP, Rene... {Caption, Description, SettingID, ArpAlwaysSourceRoute...}                                                                                                            
Win32_NetworkAdapterSetting         {}                   {Element, Setting}                                                                                                                                                    
Win32_NetworkClient                 {}                   {Caption, Description, InstallDate, Name...}                                                                                                                          
Win32_NetworkConnection             {}                   {Caption, Description, InstallDate, Name...}                                                                                                                          
Win32_NetworkLoginProfile           {}                   {Caption, Description, SettingID, AccountExpires...}                                                                                                                  
Win32_NetworkProtocol               {}                   {Caption, Description, InstallDate, Name...}                                                                                                                          
Win32_PerfFormattedData_Counters... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfFormattedData_Counters... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfFormattedData_Counters... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfFormattedData_Counters... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfFormattedData_Counters... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfFormattedData_Tcpip_Ne... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfFormattedData_Tcpip_Ne... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfRawData_Counters_Netwo... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfRawData_Counters_PerPr... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfRawData_Counters_PerPr... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfRawData_Counters_Physi... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfRawData_Counters_Remot... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfRawData_Tcpip_NetworkA... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_PerfRawData_Tcpip_NetworkI... {}                   {Caption, Description, Name, Frequency_Object...}                                                                                                                     
Win32_SystemNetworkConnections      {}                   {GroupComponent, PartComponent}
#>

Get-CimInstance -ClassName Win32reg_AddRemovePrograms
#Only works if Microsoft Endpoint Configuration Manager client installed.

Get-WmiObject -Class Win32_LogicalDisk

Get-CimInstance -ClassName Win32_LogicalDisk

#Filter
Get-WmiObject -Class Win32_LogicalDisk -Filter "DriveType=3"
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3"

#Query
Get-WmiObject -Query "SELECT * FROM Win32_LogicalDisk WHERE DriveType = 3"
Get-CimInstance -Query "SELECT * FROM Win32_LogicalDisk WHERE DriveType = 3"

#Remote
Get-WmiObject -ComputerName LON-DC1 -Credential ADATUM\Administrator -Class Win32_BIOS

Get-CimInstance -ComputerName LON-DC1 -Classname Win32_BIOS #there is not credentail in CIM but you can specify a cimsession.

#create session objects
$s = New-CimSession -ComputerName LON-DC1

$sessions = New-CimSession -ComputerName LON-CL1,LON-DC1
Get-CimInstance -CimSession $sessions -ClassName Win32_OperatingSystem


#using options

$opt = New-CimSessionOption -Protocol Dcom
$DcomSession = New-CimSession -ComputerName LON-DC1 -SessionOption $opt
Get-CimInstance -ClassName Win32_BIOS -CimSession $DcomSession

#Removing sessions
$sessions | Remove-CimSession
Get-CimSession -ComputerName LON-DC1 | Remove-CimSession
Get-CimSession | Remove-CimSession

#region begin process end block
param($computer)
begin{$s = New-CimSession -ComputerName $computer}
process{ Get-CimInstance -CimSession $s -ClassName win32_bios}
end{Remove-CimSession -ComputerName $computer}
#endregion



#region Discover methods of repository objects by using CIM and WMI
Get-WmiObject -Class Win32_Service | Get-Member -MemberType Method
Get-CimInstance -ClassName Win32_Service | Get-Member -MemberType Method

Get-CimClass -Class Win32_Service | Select-Object -ExpandProperty CimClassMethods
<#
Name                  ReturnType Parameters                                                      Qualifiers                         
----                  ---------- ----------                                                      ----------                         
StartService              UInt32 {}                                                              {MappingStrings, ValueMap}         
StopService               UInt32 {}                                                              {MappingStrings, ValueMap}         
PauseService              UInt32 {}                                                              {MappingStrings, ValueMap}         
ResumeService             UInt32 {}                                                              {MappingStrings, ValueMap}         
InterrogateService        UInt32 {}                                                              {MappingStrings, ValueMap}         
UserControlService        UInt32 {ControlCode}                                                   {MappingStrings, ValueMap}         
Create                    UInt32 {DesktopInteract, DisplayName, ErrorControl, LoadOrderGroup...} {MappingStrings, Static, ValueMap} 
Change                    UInt32 {DesktopInteract, DisplayName, ErrorControl, LoadOrderGroup...} {MappingStrings, ValueMap}         
ChangeStartMode           UInt32 {StartMode}                                                     {MappingStrings, ValueMap}         
Delete                    UInt32 {}                                                              {MappingStrings, ValueMap}         
GetSecurityDescriptor     UInt32 {Descriptor}                                                    {implemented, Privileges, ValueMap}
SetSecurityDescriptor     UInt32 {Descriptor}                                                    {implemented, Privileges, ValueMap}

#>

$WmiSpoolerService = Get-WmiObject -Class Win32_Service -Filter "Name='Spooler'"
$WmiSpoolerService.StopService()

#change start mode to manual
$WmiSpoolerService.ChangeStartMode("Manual")

$WmiSpoolerService.GetMethodParameters("Change")
<#
__GENUS                    : 2
__CLASS                    : __PARAMETERS
__SUPERCLASS               : 
__DYNASTY                  : __PARAMETERS
__RELPATH                  : 
__PROPERTY_COUNT           : 11
__DERIVATION               : {}
__SERVER                   : 
__NAMESPACE                : 
__PATH                     : 
DesktopInteract            : 
DisplayName                : 
ErrorControl               : 
LoadOrderGroup             : 
LoadOrderGroupDependencies : 
PathName                   : 
ServiceDependencies        : 
ServiceType                : 
StartMode                  : 
StartName                  : 
StartPassword              : 
PSComputerName             : 
#>
$WimSpoolerService.Change($null,"Printer Service")

Get-WmiObject -Class Win32_OperatingSystem | Invoke-WmiMethod -Name Win32Shutdown -Argument 0
Invoke-WmiMethod -Class Win32_OperatingSystem -Name Win32Shutdown -Argument 0

Invoke-CimMethod -ComputerName LON-DC1 -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine='Notepad.exe'}
Invoke-CimMethod  -ClassName Win32_Process -MethodName Create -Arguments @{CommandLine='Notepad.exe'}

Get-CimInstance -ClassName Win32_Process -Filter "Name='notepad.exe'" | Invoke-CimMethod -MethodName Terminate
Get-CimInstance -ClassName Win32_Process -Filter "Name='notepad.exe'" -Computername LON-DC1 | Invoke-CimMethod -MethodName Terminate






#endregion
