break;

Invoke-CimMethod -ClassName Win32_Process -MethodName Create -Arguments @{ CommandLine = 'Notepad'}

Invoke-CimMethod -Query 'SELECT * FROM Win32_Process WHERE Name Like "Notepad%"' -MethodName "Terminate"


