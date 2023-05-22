Function makeManifestSecondPass {
<#
.Synopsis
   This pass ignores orphaned SIDs empty groups and priveleged accounts and if the ACE count is lower than the threshold
   it adds the ACEs to the manifest
.DESCRIPTION
   This pass filters out empty groups orphaned SIDs priveleged accounts it sends the files and folders that still have too many ACEs to the next phase.
   For the ones that are now beneath the theshold it adds them to the manifest to be applied to the new share.
.EXAMPLE
   makeManifestSecondPass -fpath $fpath -manifestPath $manifestPath
.EXAMPLE
   makeManifestSecondPass -fpath $fpath -manifestPath $manifestPath -verbose
#>    
    [cmdletbinding()]
    param($fpath,
        $manifestPath
    )
    
    Begin{
        
        $count = 0
        $output = @()
        $acls = (Get-Acl -Path $fpath).Access
    }
    Process{   
        foreach($acl in $acls){
            if($Acl.IsInherited -eq $true){
                continue
            }

            $id = ($acl.IdentityReference.Value).Split('\')[1]
            $s = ($acl.IdentityReference.Value).Split('\')[0]
            $server = ""
            if($s -eq 'student'){$server = "student.ad.curtin.edu.au"}else{$server = "staff.ad.curtin.edu.au"} 
            if(($Acl.IdentityReference -like "staff\*" -or $Acl.IdentityReference -like "student\*" ) -and $Acl.IdentityReference -notmatch "^STAFF\\\w{2}\.\d{6}[A-Z|a-z|0-9]$"){
                #look for empty groups and skip them.
                try{if((Get-ADGroup -Identity $id -Server $server -ErrorAction Stop).objectclass -eq "group" -and ((Get-ADGroupMember -Identity $id -Server $server -ErrorAction Stop).count -eq 0)){continue}}
                catch{$fpath | Out-File $pathPass3 -Append ; continue}
                if($acl.FileSystemRights -like "*FullControl*"){
                        $accessLetter = "F"
                }Elseif(($acl.FileSystemRights -like "*Modify*")){
                    $accessLetter = "M"
                }Elseif(($acl.FileSystemRights -like "*Write*")){
                    $accessLetter = "W"
                }else{
                    $accessLetter = "RX"
                }
                #test file or directory

                if((Get-Item -Path $fpath).Attributes -eq "Directory"){
                    Write-Host "$($fpath) is a directory" -ForegroundColor Magenta
                    $access = "(OI)(CI)({0})" -f $accessLetter
                    $output  +=  'icacls --% "{0}" /grant "{1}":{2}' -f $fpath, $acl.IdentityReference, $access 
                    

            
                }else{
                    Write-Host "$($fpath) is a file" -ForegroundColor yellow
                    $output  += 'icacls --% "{0}" /grant "{1}":({2})' -f $fpath, $acl.IdentityReference, $accessLetter 
                }
                
                $count++
            }
        }

        if($count -lt 9){
            $Output | Out-File $manifestPath -Encoding ascii -Append
        }else{
            $fpath | Out-File $pathPass3 -Append
        }
    }
    end{
        $clean = get-content $pathPass3 | Select-Object -Unique
        $clean | Out-File $pathPass3

    }
}

$pathPass3 = "C:\temp\VC\pass3.txt"
$pathPass2 = "C:\temp\VC\pass2.txt"
$manifestPath = "C:\temp\Manifest2.ps1"
$fpaths = Get-Content $pathPass2  

foreach($fpath in $fpaths){
    Write-Host $fpath -ForegroundColor Green
    makeManifestSecondPass -fpath $fpath -manifestPath $manifestPath
}

break
################################Break Line any thing below this point will not be run #################################
Test-Path $pathPass2
if(Test-Path $pathPass3){Remove-Item $pathPass3 -Verbose}
if(Test-Path $manifestPath){Remove-Item $manifestPath -Verbose}