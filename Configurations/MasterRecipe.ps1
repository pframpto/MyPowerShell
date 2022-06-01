Break;

<#
This is meant to be one file that can be dropped on any server and build any configuration 
using the needed parts.
Just select what is needed and then Run selection F8 from the ise.
#>

Set-TimeZone -Id 'E. Australia Standard Time'


#region set networking

New-NetIPAddress -IPAddress 192.168.1.106 -DefaultGateway 192.168.1.1  -PrefixLength 24 -InterfaceAlias "ethernet" 
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 8.8.8.8

#endregion

Install-PackageProvider -Name NuGet -Force

#region install chrome

Install-module xchrome -force


configuration InstallChrome {
    Import-DSCResource -Module xchrome -Name msft_xchrome

    node localhost {
        msft_xchrome installme
        {
            language = 'en'
        }
        

    }

}

InstallChrome -outputpath c:\dsc\config
break
Start-DscConfiguration -Path C:\dsc\config -ComputerName localhost  -Verbose -wait -force

#endregion


#region install git

Install-Script -Name Install-Git -Force
Install-Git.ps1
$env:Path +=";C:\Program Files\Git\bin"

#endregion


#region install vscode

Install-Script -Name Install-VSCode -Force
break;
Install-VSCode

#endregion

#region install python latest version

Install-Module -Name PythonPowershellUtilities
break;
Install-Python -FullVersion 3.9.3 
$env:Path += ";C:\PythonInstallations\python3.9"

#endregion


#region install php

mkdir c:\temp
#if the url does not work go to site and update it.
Invoke-WebRequest -Uri 'https://windows.php.net/downloads/releases/php-8.1.2-Win32-vs16-x64.zip' -OutFile c:\temp\php.zip
Expand-Archive -LiteralPath 'C:\temp\php.Zip' -DestinationPath C:\PHP -Force
$env:path += ";c:\php"

mkdir C:\Users\Administrator\www
New-Item -Path C:\Users\Administrator\www -Name test.php -Value '<html><head></head><body><h1>See if this works</h1></body></html>'

start msedge http://localhost:4000/www/test.php

php -S localhost:4000

#if you get a vc140 something error here download https://aka.ms/vs/17/release/vc_redist.x64.exe and this might fix it.
# Invoke-WebRequest -Uri https://aka.ms/vs/17/release/vc_redist.x64.exe -OutFile C:\temp\vc_redist.x64.exe 


#endregion

#region install node.js
Install-Module -Name nvm

Install-NodeVersion v16

#endregion

#region install react app
#First install nodejs then from inside vscode run these commands.



<#
npx create-react-app my-app
cd my-app
npm start
#>
#endregion










