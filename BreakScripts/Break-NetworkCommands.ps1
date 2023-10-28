# Add all the basic network commands to this break script
break;

#ping
Test-Connection -ComputerName localhost -Protocol DCOM #wsman

#test open ports

Test-NetConnection -ComputerName localhost -Port 3389

#tracert 

Test-NetConnection -ComputerName localhost -TraceRoute

#find the interface alias (usually it will be Ethernet)
(Get-NetAdapter).ifAlias

#set ip address
New-NetIPAddress -IPAddress 192.168.1.99 -DefaultGateway 192.168.1.1  -PrefixLength 24 -InterfaceAlias "ethernet"


#set ip dhcp
Set-NetIPInterface -InterfaceAlias "Ethernet" -Dhcp Enabled

#set client dns server
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 192.168.1.2, 192.168.1.3


#get mac address
(Get-NetAdapter).MacAddress

#get ipv4 address
(Get-NetIPAddress -InterfaceAlias ethernet -AddressFamily IPv4).IPAddress

#nslookup
Resolve-DnsName example.com
Resolve-DnsName -Name 8.8.8.8 -Type PTR
Resolve-DnsName example.com -Type MX



#dhcp refresh
Invoke-Command -ScriptBlock { ipconfig /renew } -ComputerName .

#region Firewall

    # Enable firewall for all profiles
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

    # Disable firewall for all profiles
    Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled False

    # Create an inbound rule to allow ICMP Echo Requests (ping)
    New-NetFirewallRule -DisplayName "Allow ICMP Echo Requests" -Protocol ICMPv4 -IcmpType 8 -Action Allow

    # Allow port 8080
    New-NetFirewallRule -DisplayName "Allow Port 8080" -Direction Inbound -LocalPort 8080 -Action Allow

    # rename a rule
    Set-NetFirewallRule -DisplayName "Old Rule Name" -DisplayName "New Rule Name"

    # enable or disable firewall rules
    Disable-NetFirewallRule -DisplayName "Rule Name"
    Enable-NetFirewallRule -DisplayName "Rule Name"

    # remove a firewall rule
    Remove-NetFirewallRule -DisplayName "Rule Name"

#endregion

# nestsh is like Get-NetTCPConnection

(Get-NetTCPConnection).RemoteAddress | Where {$_ -notlike "52.*" -and $_ -notlike "::" -and $_ -notlike "0.0.0.0"}

#Think of other things to add.

