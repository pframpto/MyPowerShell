Break;

# Enable over Http
Set-WSManQuickConfig

# Enable over Https
Set-WSManQuickConfig -UseSSL

# Enable Remoting
Enable-PSRemoting -Force

Enable-PSRemoting -Force -SkipNetworkProfileCheck

#### PREPARE WINDOWS FOR SSH REMOTING ####
# Insall OpenSSH Client and Server

Add-WindowsCapability -Online -Name OpenSSH.Client
Add-WindowsCapability -Online -Name OpenSSH.Server

# Set the SSH Server Service to Start Automatically
Set-Service -Name sshd -StartupType Automatic
Start-Service -Name sshd

# Install and Import ps remoting module
Install-Module -name Microsoft.Powershell.RemotingTools
Import-Module -name Microsoft.Powershell.RemotingTools

# Enable SSH Remoting and Restart the Service
Enable-sshRemoting -Verbose
Restart-Service -name sshd

#### PREPARE LINUX FOR SSH REMOTING ####

# Install openssh client and server
sudo yum -y install openssh-server openssh-clients

# Start the SSH Server Service
sudo systemctl start sshd
sudo systemctl status sshd

# Enable the OpenSSH Service
sudo systemctl enable sshd

# Modify the ssh server configuration and restart
sudo vim /etc/ssh/sshd_config
service sshd restart

##############
# connect from windows to linux
Enter-PSSession -HostName 192.168.20.11 -UserName paul -SSHTransport

$session = New-PSSession -HostName 192.168.20.11 -UserName paul -SSHTransport

