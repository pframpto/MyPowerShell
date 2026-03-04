break;

#region invoke-Command

$computers = 'LonCL1','LonSVR1','LonDC1'
help Invoke-Command -Parameter ThrottleLimit

# The -ComputerName parameter is best for ad-hoc commands
Invoke-Command -ComputerName $computers {$log = Get-EventLog -LogName Security -Newest 100;$log}
Invoke-Command -ComputerName $computers {$log} # $log is empty because a session wasn't used

$sessionAll = New-PSSession -ComputerName $computers
Invoke-Command -Session $sessionAll {$log = Get-EventLog -LogName Security -Newest 100;$log}
Invoke-Command -Session $sessionAll {$log} # $log variable is maintained in the session

Invoke-Command -Session $sessionAll {$log} | Sort PSComputerName
Invoke-Command -Session $sessionAll {$log} | Sort PSComputerName | Format-Table -GroupBy PSComputerName

#endregion

#region jobs

# 10.2 Background Jobs

For($i = 1;$i -le 10;$i++){
    Start-Job -ScriptBlock {dir C:\ -Recurse}
}


get-job

#endregion

#region workflows

# 10.3.1 Workflows

WorkFlow Test-Parallel {
    "First line executes"
    Parallel{
        sleep 2
	    1
	    2
        sleep 2
	    3
	    4
        sleep 2
	    5
	    6
        sleep 2
	    7
	    8
	    9
	    Sequence{
		    "A"
		    "B"
	    }
    }
}

Test-Parallel


# 10.3.2 Workflows Continued

Workflow PingSweep{
    $computers = @()
    For ($i = 1; $i -le 50; $i++){$computers += "172.16.0.$i"}
    ForEach -Parallel ($computer in $computers){
        If(Test-NetConnection -computerName $computer -InformationLevel Quiet -WarningAction SilentlyContinue){
            Write-Output -InputObject "$computer,ONLINE"
        }else{
            Write-Output -InputObject "$computer,OFFLINE"
        }
    }
}

PingSweep | ForEach{
    $ip = $_.Split(",")[0]
    $status = $_.Split(",")[1]
    If($status -eq 'ONLINE'){
        Write-Host "$ip" -ForegroundColor Green
    }Else{
        Write-Host "$ip" -ForegroundColor Red
    }
}

#endregion

#region ps7 foreach -parallel

# 10.4 PowerShell 7+ ForEach-Object -Parallel

#requires -version 7

1..50 | ForEach-Object -Parallel {
    If(Test-NetConnection -computerName "172.16.0.$_" -InformationLevel Quiet -WarningAction SilentlyContinue){
            Write-Host "172.16.0.$_`n" -ForegroundColor Green -NoNewline
    }Else{
        Write-Host "172.16.0.$_`n" -ForegroundColor Red -NoNewline
    }
}

#endregion

#region .net Runspaces

# 10.5 .Net Runspaces
#Requires -modules WFTools 
Find-Command Invoke-Parallel
<# the one we are interested in is WFTools

Name                                Version    ModuleName                          Repository                                                                                                 
----                                -------    ----------                          ----------                                                                                                 
Invoke-Parallel                     1.2.5      PSParallelPipeline                  PSGallery                                                                                                  
Invoke-Parallel                     2.2.2      PSParallel                          PSGallery                                                                                                  
Invoke-Parallel                     0.1.58     WFTools                             PSGallery                                                                                                  
Invoke-Parallel                     2.9.9      XpandPosh                           PSGallery                                                                                                  
Invoke-Parallel                     2.9.9      XpandPosh                           PSGallery                                                                                                  
Invoke-Parallel                     1.252.0.6  XpandPwsh                           PSGallery                                                                                                  
Invoke-Parallel                     1.1        PSKantan                            PSGallery 
#>



Install-Module WFTools

#requires -modules 'WFTools'

1..127 | Invoke-Parallel -Throttle 32 -ScriptBlock {
    If(Test-Connection "192.168.20.$_" -Count 1 -Quiet){
        Write-Host "192.168.20.$_`n" -ForegroundColor Green -NoNewline
    }Else{
       # Write-Host "172.16.0.$_`n" -ForegroundColor Red -NoNewline
    }
}









