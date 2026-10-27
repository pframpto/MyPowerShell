break;

#region recursion
Get-ChildItem c:\temp -Recurse | Select-Object FullName

Measure-Command -Expression {
    [System.IO.Directory]::GetDirectories("c:\temp", "*", [System.IO.SearchOption]::AllDirectories)
}
Measure-Command -Expression {
    [System.IO.Directory]::EnumerateDirectories("C:\temp")
}

#get directories at a set length
$dirs = @('c:\temp\')
$depth = 2
for ($i = 0; $i -lt $depth; $i++) {
    $dirs = foreach ($dir in $dirs) {
        [System.IO.Directory]::EnumerateDirectories($dir)
    }
}
$dirs

#files and directories
$filesAndDirectories = [System.IO.Directory]::GetFileSystemEntries("c:\temp")
$filesAndDirectories

#just files
[System.IO.Directory]::EnumerateFiles("C:\temp")

$dir = @('c:\temp\')

$dirs = [System.IO.Directory]::EnumerateFiles($dir)
$dirs
#get files at a certain depth.
$dirs = @('c:\temp\')
$depth = 3
for ($i = 0; $i -lt $depth; $i++) {
    $dirs = foreach ($dir in $dirs) {
        [System.IO.Directory]::EnumerateDirectories($dir)
        
    }
}
#$dirs
foreach($file in $dirs){
    
    [System.IO.Directory]::EnumerateFiles($file)
}

#endregion

#region array types

#endregion

#region dot net runspaces

    # 10.5 .Net Runspaces
    #Requires -version 7

    #Find-Command Invoke-Parallel

    #Install-Module WFTools
    Measure-Command -Expression {
        1..50 | Invoke-Parallel -Throttle 32 -ScriptBlock {
            If(Test-Connection "192.168.20.$_" -Count 1 -Quiet){
                Write-Host "192.168.20.$_`n" -ForegroundColor Green -NoNewline
            }Else{
                Write-Host "192.168.20.$_`n" -ForegroundColor Red -NoNewline
            }
        }
    }

#endregion




$accessInfos = New-Object System.Security.AccessControl.DirectorySecurity("c:\temp", 6)
foreach($access in $accessInfos.Access){
    if($access.identityReference -like "BUILTIN\*"){
        continue
    }
    $access
}