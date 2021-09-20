Param([parameter(Mandatory=$true)][string[]]$computers)
foreach($computer in $computers){
    $win32CS = Get-CimInstance -ClassName win32_computersystem -ComputerName $computer 
    $win32OS = Get-CimInstance -ClassName win32_operatingsystem -ComputerName $computer

    $joinedOutput = @{
        'Computername'=$computer;
        'Memory'=$win32CS.TotalPhysicalMemory;
        'Free Memory'=$win32OS.FreePhysicalMemory;
        'Procs'=$win32CS.NumberOfProcessors;
        'Version'=$win32OS.Version
    }

    $outOjb = New-Object -TypeName psobject -Property $joinedOutput
    Write-Output $outOjb
}