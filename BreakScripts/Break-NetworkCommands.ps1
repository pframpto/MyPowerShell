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



#Think of other things to add.

