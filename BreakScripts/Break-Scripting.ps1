break;
#region Review the PowerShellGet module in Windows PowerShell
#Cmdlets used to find content in the PowerShell Gallery
<#
Cmdlet	Description
Find-Module	Use this cmdlet to search for Windows PowerShell modules in the PowerShell Gallery. 
            The simplest usage conducts searches based on the module name, but you can also search based on the command name, version, DscResource, and RoleCapability.
Find-Script	Use this cmdlet to search for Windows PowerShell scripts in the PowerShell Gallery. 
            The simplest usage conducts searches based on the script name, but you can also search based on the version.

#>

#To enable TLS 1.2 for the current PowerShell prompt, run the following command:
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#To fix this issue permanently on a computer, you need to create registry keys. You can run the following two commands to create the necessary keys:
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319'-Name 'SchUseStrongCrypto' -Value '1' -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord

#Run scripts and set the execution policy in Windows PowerShell


Powershell.exe -ExecutionPolicy ByPass

Unblock-File #this is used to change a scipted marked as downloaded 

#Sign the scripts digitally in Windows PowerShell
$cert =  Get-ChildItem -Path "Cert:\CurrentUser\My" -CodeSigningCert
Set-AuthenticodeSignature -FilePath "C:\Scripts\MyScript.ps1" -Certificate $cert

#endregion

#region Work with scripting constructs in Windows PowerShell

ForEach ($user in $users) {
     Set-ADUser $user -Department "Marketing"
}

$users | ForEach-Object -Parallel { Set-ADUser $user -Department "Marketing" }
#pwsh 7 has -parallel it also has the optional parameter -ThrottleLimit

#Review and use the If construct in Windows PowerShell scripts
#The If construct uses the following syntax:
If ($freeSpace -le 5GB) {
   Write-Host "Free disk space is less than 5 GB"
} ElseIf ($freeSpace -le 10GB) {
   Write-Host "Free disk space is less than 10 GB"
} Else {
   Write-Host "Free disk space is more than 10 GB"
}


#Review and use the Switch construct in Windows PowerShell scripts
#he Switch construct uses the following syntax:

Switch ($choice) {
   1 { Write-Host "You selected menu item 1" }
   2 { Write-Host "You selected menu item 2" }
   3 { Write-Host "You selected menu item 3" }
   Default { Write-Host "You did not select a valid option" }
}

#The following example uses pattern matching:

Switch -WildCard ($ip) {
   "10.*" { Write-Host "This computer is on the internal network" }
   "10.1.*" { Write-Host "This computer is in London" }
   "10.2.*" { Write-Host "This computer is in Vancouver" }
   Default { Write-Host "This computer is not on the internal network" }
 }

#The For construct uses the following syntax:

For($i=1; $i -le 10; $i++) {
   Write-Host "Creating User $i"
}

#Review other loop constructs in Windows PowerShell scripts

#The Do..While construct uses the following syntax:

Do {
   Write-Host "Script block to process"
} While ($answer -eq "go")


#The Do..Until construct uses the following syntax:

Do {
   Write-Host "Script block to process"
} Until ($answer -eq "stop")
#this script runs at least once

#The While construct uses the following syntax:

While ($answer -eq "go") {
   Write-Host "Script block to process"
}

#Review Break and Continue in Windows PowerShell scripts

ForEach ($user in $users) {
   If ($user.Name -eq "Administrator") {Continue}
   Write-Host "Modify user object"
}
#this will skip the iteration that has administrator and will print everything else

ForEach ($user in $users) {
   $number++
   Write-Host "Modify User object $number"
   If ($number -ge $max) {Break}
}
#if the number gets to the max value then the loop stops.

#endregion

#region Import data in different formats for use in scripts by using Windows PowerShell cmdlets

#Use the Get-Content command in Windows PowerShell scripts

$computers = Get-Content C:\Scripts\computers.txt

Get-Content -Path "C:\Scripts\*" -Include "*.txt","*.log"

Get-Content C:\Scripts\computers.txt -TotalCount 10

#Use the Import-Csv cmdlet in Windows PowerShell scripts
$users = Import-Csv C:\Scripts\Users.csv

#Example data for Users.csv:

<#
First,Last,UserID,Department
Amelie,Garner,AGarner,Sales
Evan,Norman,ENorman,Sales
Siu,Robben,SRobben,Sales
#>


$users[2].UserID

#Use the Import-Clixml cmdlet in Windows PowerShell scripts
$users = Import-Clixml C:\Scripts\Users.xml

#Use the ConvertFrom-Json cmdlet in Windows PowerShell scripts
$users = Get-Content C:\Scripts\Users.json | ConvertFrom-Json

$users = Invoke-RestMethod "https://hr.adatum.com/api/staff"

#endregion

#region Use methods to accept user inputs

##Identify values that might change in Windows PowerShell scripts
$answer = Read-Host "How many days"
#     How many days:

Write-Host "How many days? " -NoNewline
$answer = Read-Host

# -MaskInput (PS7) or -AsSecureString 

$password = Read-Host "What is the password" -AsSecureString

$a = (read-host "enter a number" -MaskInput) -as [int]
#returns an integer otherwise any number entered is a string.

##Use the Get-Credential cmdlet

$cred = Get-Credential
Set-ADUser -Identity $user -Department "Marketing" -Credential $cred
# -Message parameter. You can also fill in the User name box by using the -UserName parameter.

#Storing credentials by using Export-Clixml
$cred | Export-Clixml C:\cred.xml

#SecretManagement module
Install-Module Microsoft.PowerShell.SecretManagement

#Get-Command -Module Microsoft.PowerShell.SecretManagement
<#
CommandType     Name                                               Version    Source                                                                                                                                           
-----------     ----                                               -------    ------                                                                                                                                           
Cmdlet          Get-Secret                                         1.1.2      Microsoft.PowerShell.SecretManagement                                                                                                            
Cmdlet          Get-SecretInfo                                     1.1.2      Microsoft.PowerShell.SecretManagement                                                                                                            
Cmdlet          Get-SecretVault                                    1.1.2      Microsoft.PowerShell.SecretManagement                                                                                                            
Cmdlet          Register-SecretVault                               1.1.2      Microsoft.PowerShell.SecretManagement                                                                                                            
Cmdlet          Remove-Secret                                      1.1.2      Microsoft.PowerShell.SecretManagement                                                                                                            
Cmdlet          Set-Secret                                         1.1.2      Microsoft.PowerShell.SecretManagement                                                                                                            
Cmdlet          Set-SecretInfo                                     1.1.2      Microsoft.PowerShell.SecretManagement                                                                                                            
Cmdlet          Set-SecretVaultDefault                             1.1.2      Microsoft.PowerShell.SecretManagement                                                                                                            
Cmdlet          Test-SecretVault                                   1.1.2      Microsoft.PowerShell.SecretManagement                                                                                                            
Cmdlet          Unlock-SecretVault                                 1.1.2      Microsoft.PowerShell.SecretManagement                                                                                                            
Cmdlet          Unregister-SecretVault                             1.1.2      Microsoft.PowerShell.SecretManagement
#>


##Use the Out-GridView cmdlet in Windows PowerShell scripts

$selection = $users | Out-GridView -PassThru

#Values that can be defined for the -OutputMode parameter
<#
Value	Description
None	This is the default value that doesn't pass any objects further down the pipeline.
Single	This value allows users to select zero rows or one row in the Out-GridView window.
Multiple	This value allows users to select zero rows, one row, or multiple rows in the Out-GridView window. This value is equivalent to using the -PassThru parameter.
#>

##Pass parameters to a Windows PowerShell script
Param(
   [string]$ComputerName ,
   [int]$EventID
)

.\GetEvent.ps1 -ComputerName LON-DC1 -EventID 5772

#default value in parameter block
Param(
   [string]$ComputerName = "LON-DC1"
)


#The following example depicts how to prompt users for input:
Param(
   [int]$EventID = Read-Host "Enter event ID"
)

#endregion

#region Troubleshoot scripts and handle errors in Windows PowerShell

#Interpret error messages generated for Windows PowerShell commands
$Error #all errors in memory
$Error[0] #last error
#Add output to Windows PowerShell scripts
# Cmdlets for troubleshooting
<#
  Cmdlet	               Description
Write-Verbose	Text specified by Write-Verbose is displayed only when you use the -Verbose parameter when running the script. 
                The value of $VerbosePreference specifies the action to take after 
                the Write-Verbose command. The default action is SilentlyContinue.

Write-Debug	    Text specified by Write-Debug is displayed only when you use the -Debug parameter when running the script. 
                The value of $DebugPreference specifies the action to take after the Write-Debug command. 
                The default action is SilentlyContinue, which displays no information to screen. 
                You need to change this action to Continue so that debug messages are displayed.
#>

#Use breakpoints in Windows PowerShell scripts
Set-PSBreakPoint -Script "MyScript.ps1" -Line 23

# Set breakpoint for specific command
Set-PSBreakPoint -Command "Set-ADUser" -Script "MyScript.ps1"

# Set breakpoint for variable
Set-PSBreakPoint -Variable "computer" -Script "MyScript.ps1" -Mode ReadWrite

#Interpret error actions for Windows PowerShell commands

Get-WmiObject -Class Win32_BIOS -ComputerName LON-SVR1,LON-DC1 #if svr1 failed the script would not terminate it would go onto 2

$ErrorActionPreference
<#
Continue              is the default, and it tells the command to display an error message and continue to run.
SilentlyContinue      tells the command to display no error message, but to continue running.
Inquire               tells the command to display a prompt asking the user what to do.
Stop                  tells the command to treat the error as terminating and to stop running.
#>

#endregion

#region use functions and modules in Powershell Scripts
##Review functions in Windows PowerShell scripts
Function Get-SecurityEvent {
   Param (
      [string]$ComputerName
   ) #end Param
   Get-EventLog -LogName Security -ComputerName -$ComputerName -Newest 10
}
#call the function
Get-SecurityEvent -ComputerName LON-DC1
#assign function result ot a variable
$securityEvents = Get-SecurityEvent -ComputerName LON-DC1

##Use variable scope in Windows PowerShell scripts
#Scopes
<#
Scope	         Description
Global	    The global scope is for the Windows PowerShell prompt. 
            Variables set at the Windows PowerShell prompt can be reviewed in all the scripts started at that Windows PowerShell prompt. 
            Variables created at a Windows PowerShell prompt don't exist in other Windows PowerShell prompts or in instances of the Windows 
            PowerShell Integrated Scripting Environment (ISE).
Script	    The script scope is for a single script. 
            Variables set within a script can be reviewed by all the functions within that script. 
            If you set a variable value in the script scope that already exists in the global scope, a new variable is created in the script scope. 
            There are then two variables of the same name in two separate scopes. At this point, when you review the value of the variable in the script, 
            the value of the variable in the script scope is returned.
Function	The function scope is for a single function. 
            Variables set within a function aren't shared with other functions or the script. 
            If you set a variable value in the function scope that already exists in the global or script scope, 
            a new variable is created in the function scope. Then, there are two variables of the same name in two separate scopes.
#>

# To modify a script scope variable from a function, use the following syntax:
$script:var = "Modified from function"

# use Return() at the end of a function to pass a variable value back to the script scope:
Return($users)

##Create modules in Windows PowerShell scripts

# Windows PowerShell 5.0, the following paths are listed:
<#
    C:\Users\UserID\Documents\WindowsPowerShell\Modules
    C:\Program Files\WindowsPowerShell\Modules
    C:\Windows\System32\WindowsPowerShell\1.0\Modules
#>
# PowerShell 7 includes the following other paths:
<#
    C:\Program Files\PowerShell\Modules
    C:\Program Files\PowerShell\7\Modules
#>

##Use the dot sourcing feature in Windows PowerShell
# The syntax for using dot sourcing is:
. C:\scripts\functions.ps1

#endregion









