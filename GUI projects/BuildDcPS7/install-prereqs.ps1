Set-TimeZone -Id 'E. Australia Standard Time'
Install-PackageProvider -Name NuGet -Force
(Invoke-Expression "& { $(Invoke-RestMethod https://aka.ms/install-powershell.ps1) } -UseMSI")