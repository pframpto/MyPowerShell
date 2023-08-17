Break;

(Get-ControlPanelItem -Name *).Name

Show-ControlPanelItem -Name "Devices and Printers"
$clipItem = Get-Clipboard
Show-ControlPanelItem -Name $clipItem

#CONTROL PANEL ITEMS
<#     
Security and Maintenance
Windows Tools
AutoPlay
Backup and Restore (Windows 7)
BitLocker Drive Encryption
Color Management
Credential Manager
Date and Time
Default Programs
Device Manager
Devices and Printers
Ease of Access Center
File Explorer Options
Fonts
Indexing Options
Internet Options
Keyboard
Windows Mobility Center
Mouse
Network and Sharing Center
Pen and Touch
Phone and Modem
Power Options
Programs and Features
Recovery
Region
RemoteApp and Desktop Connections
Sound
Speech Recognition
Storage Spaces
Sync Center
System
Taskbar and Navigation
Troubleshooting
User Accounts
Windows Defender Firewall
Work Folders
Mail (Microsoft Outlook)
#>