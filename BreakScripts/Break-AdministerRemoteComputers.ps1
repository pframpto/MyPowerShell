Break;
#region Review the remoting feature of Windows PowerShell

## Cmdlets that include a -ComputerName in ps5 and dont require confuguration to work
Restart-Computer
Test-Connection
Clear-EventLog
Get-EventLog
Get-HotFix
Get-Process
Get-Service
Set-Service
Get-WinEvent
Get-WmiObject

Get-Command | where { $_.parameters.keys -contains "ComputerName" -and $_.parameters.keys -notcontains "Session"}
<#

CommandType     Name                                               Version    Source                                                                                                                                           
-----------     ----                                               -------    ------                                                                                                                                           
Cmdlet          Add-Computer                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Clear-EventLog                                     3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Connect-WSMan                                      3.0.0.0    Microsoft.WSMan.Management                                                                                                                       
Cmdlet          Disconnect-WSMan                                   3.0.0.0    Microsoft.WSMan.Management                                                                                                                       
Cmdlet          Get-EventLog                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-HotFix                                         3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-Process                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-PSSession                                      3.0.0.0    Microsoft.PowerShell.Core                                                                                                                        
Cmdlet          Get-Service                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-WmiObject                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Get-WSManInstance                                  3.0.0.0    Microsoft.WSMan.Management                                                                                                                       
Cmdlet          Invoke-WmiMethod                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Invoke-WSManAction                                 3.0.0.0    Microsoft.WSMan.Management                                                                                                                       
Cmdlet          Limit-EventLog                                     3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          New-EventLog                                       3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          New-WSManInstance                                  3.0.0.0    Microsoft.WSMan.Management                                                                                                                       
Cmdlet          Register-WmiEvent                                  3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Remove-Computer                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Remove-EventLog                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Remove-WmiObject                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Remove-WSManInstance                               3.0.0.0    Microsoft.WSMan.Management                                                                                                                       
Cmdlet          Rename-Computer                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Restart-Computer                                   3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-Service                                        3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-WmiInstance                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Set-WSManInstance                                  3.0.0.0    Microsoft.WSMan.Management                                                                                                                       
Cmdlet          Show-EventLog                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Stop-Computer                                      3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Test-Connection                                    3.1.0.0    Microsoft.PowerShell.Management                                                                                                                  
Cmdlet          Test-WSMan                                         3.0.0.0    Microsoft.WSMan.Management                                                                                                                       
Cmdlet          Write-EventLog                                     3.1.0.0    Microsoft.PowerShell.Management 
#>

#PowerShell remoting over SSH
New-PSSession -UseSSL
Enter-PSSession -UseSSL
Invoke-Command -UseSSL

##Compare remoting with remote connectivity
##Review the remoting security feature of Windows PowerShell
##Enable remoting by using Windows PowerShell

Enable-PSRemoting
Disable-PSRemoting

#enable-psremoting
#1 runs Set-WSManQuickConfig
#2 restarts the winrm service

##Use one-to-one remoting by using Windows PowerShell
Enter-PSSession -ComputerName $computer 

Exit-PSSession #ends session

##Use one-to-many remoting by using Windows PowerShell

Invoke-Command –ComputerName name1,name2 –ScriptBlock { $command }
Invoke-Command –ComputerName name1,name2 –FilePath $filepath

$var = 'BITS'
Invoke-Command –ScriptBlock { Get-Service –Name $var } –Computer LON-DC1
#does not work use $using:var


Invoke-Command –ScriptBlock { Param($c) Do-Something –Credential $c }
               -ComputerName LON-DC1
               -ArgumentList (Get-Credential)

#Multiple computer names
<#
-ComputerName ONE,TWO,THREE. A static, comma-separated list of computer names.
-ComputerName (Get-Content Names.txt). Reads names from a text file named Names.txt, assuming the file contains one computer name per line.
-ComputerName (Import-Csv Computers.csv | Select –ExpandProperty Computer). Reads a comma-separated value (CSV) file that's named Computers.csv and contains a column named Computer that contains computer names.
-ComputerName (Get-ADComputer –Filter * | Select –ExpandProperty Name)
#>

##Compare remoting output with local output
Invoke-Command –Computer LON-DC1 –ScriptBlock { Get-Process –Name Note* } |
Stop-Process # does not work because deserialized results are returned.

Invoke-Command –Computer LON-DC1 –ScriptBlock { Get-Process –Name Note* | Stop-Process }
#works because it runs on the remote computer

#endregion

#region Use advanced Windows PowerShell remoting techniques
##Review common remoting techniques of Windows PowerShell
Enter-PSSession
<#
–Port. Specifies an alternate TCP port for the connection. Use this parameter when the computer to which you're connecting is listening on a port other than the default 5985 (HTTP) or 5986 (HTTPS). 
        Be aware that you can, locally or through Group Policy, configure a different port as a permanent new default.
–UseSSL. Instructs Windows PowerShell to use HTTPS instead of HTTP.
–Credential. Specifies an alternative credential for the connection. 
    This credential will be validated by the remote computer and must have sufficient privileges and permissions to perform whatever tasks you intend to perform on the remote computer.
–ConfigurationName. Connects to an endpoint (session configuration) other than the default endpoint. For example,
     you can specify microsoft.powershell32 to connect to the remote computer’s 32-bit Windows PowerShell endpoint.
–Authentication. Specifies an authentication protocol. The default is Kerberos authentication, but other options include Basic, CredSSP, Digest, Negotiate, and NegotiateWithImplicitCredential. 
        The protocol that you specify must be enabled in the WS-Management configuration on both the initiating and receiving computers.
#>

#You can configure additional session options by using New-PSSessionOption to create a new session option object
New-PSSessionOption

##Send parameters to remote computers in Windows PowerShell
$Log = 'Security'
$Quantity = 10
Invoke-Command –Computer ONE,TWO –ScriptBlock {
  Get-EventLog –LogName $Log –Newest $Quantity
}
#THIS DOES NOT WORK variables are local and do not exist in scriptblock

$Log = 'Security'
$Quantity = 10
Invoke-Command –Computer ONE,TWO –ScriptBlock {
  Param($x,$y) Get-EventLog –LogName $x –Newest $y
} –ArgumentList $Log,$Quantity
#this is a better way of doing this.

Invoke-Command –ScriptBlock { Do-Something $Using:variable } –ComputerName REMOTE
#This is my prefered way of doing this.

##Set access protection to variables, aliases, and functions by using the scope modifier
$ps = "Windows PowerShell"
Invoke-Command -ComputerName LON-DC1 -ScriptBlock {Get-WinEvent -LogName $Using:ps}

$s = New-PSSession -ComputerName LON-DC1
$ps = "Windows PowerShell"
Invoke-Command -Sessions $s -ScriptBlock {Get-WinEvent -LogName $Using:ps}

##Enable multi-hop remoting in Windows PowerShell
#Enabling CredSSP
#You must enable the CredSSP protocol both on the initiating computer, referred to as the client, and on the receiving computer, referred to as the server. 
Enable-WsManCredSSP –Role Client –Delegate servername #substitute servername with the name of the server that will be able to redelegate your credential:
Enable-WsManCredSSP –Role Server
#This is not recommended as it is a serious security concern.

#Resource-based, Kerberos-constrained delegation
Add-WindowsFeature RSAT-AD-PowerShell
Import-Module ActiveDirectory
#To grant resource-based, Kerberos-constrained delegation from LON-SVR1 through LON-SVR2 to LON-SVR3, run the following command:
Set-ADComputer -Identity LON-SVR2 -PrincipalsAllowedToDelegateToAccount LON-SVR3
#To test constrained delegation, run the following code example:
$cred = Get-Credential Adatum\TestUser                
Invoke-Command -ComputerName LON-SVR1.Name -Credential $cred -ScriptBlock {Test-Path \\$($using:ServerC.Name)\C$ Get-Process lsass -ComputerName $($using:LON-SVR2.Name)
Get-EventLog -LogName System -Newest 3 -ComputerName $using:LON-SVR3.Name            
}

#Just enough administration
# You can create a new PowerShell role capability file with the New-PSRoleCapabilityFile cmdlet
#endregion

#region Manage persistent connections to remote computers by using Windows PowerShell sessions

##Review persistent connections in Windows PowerShell
# You can explore these configuration parameters by running dir WSMan:\localhost\shell

##Create and manage persistent PSSessions by using Windows PowerShell
# Both the Invoke-Command and Enter-PSSession commands can accept a PowerShell session object
$client = New-PSSession –ComputerName LON-CL1
Enter-PSSession –Session $client
Exit-PSSession

$computers = New-PSSession –ComputerName LON-CL1,LON-DC1
Invoke-Command –Session $computers –ScriptBlock { Get-Process }

$dc = New-PSSession –ComputerName LON-DC1

$s = New-PSSession -ComputerName Server01, Server02

Invoke-Command -Session $s {$h = Get-HotFix}
#   because the sessions are persistent you can follow this command with
Invoke-Command -Session $s {$h | where {$_.InstalledBy -ne "NTAUTHORITY\SYSTEM"}}
#   and the $h stays resident in memory

##Disconnect PSSessions by using Windows PowerShell
#Using disconnected sessions is similar to the following process:
<#
Use New-PSSession to create the new PSSession. Optionally, use the PSSession to run commands.
Run Disconnect-PSSession to disconnect from the PSSession. Pass the PSSession object that you want to disconnect from to the command’s –Session parameter.
Optionally, move to another computer and open Windows PowerShell.
Run Get-PSSession with the –ComputerName parameter to obtain a list of your PSSessions running on the specified computer.
Use Connect-PSSession to reconnect to the desired PSSession.
#>

##Review the feature of implicit remoting in Windows PowerShell

$cred = Get-Credential -Credential 
$dcSession = New-PSSession -ComputerName '10.0.0.11' -Credential $cred
Import-PSSession -Session $dcSession -Prefix PDT -Module activedirectory

#endregion