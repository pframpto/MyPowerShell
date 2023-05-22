#This pass collects files and folders with less than 7 ACEs and writes them to a mainfest. 
# this filters out system groups. 
#

function MakeMainfest {
    <#
    .Synopsis
       This script takes all of the files and folders with an ACE count that is less than the threshold and writes them straight to the manifest.
    .DESCRIPTION
       This script takes all of the files and folders with an ACE count that is less than the threshold and writes them straight to the manifest.
       It scipts all the inherited permissions.
       But before writing to the manifest it strips out all entries that do not match the patern staff\* or student\* or entries that match priveleged accounts
       The manifest after this stage will generally have two to three entries left after the other accounts have been striped out.
       The files and folders with too many entries will be passed onto the next pass.
    .EXAMPLE
       MakeMainfest -fileOrDirectoryPath l:\per -manifestPath c:\temp\aclsToAdd.ps1
    .EXAMPLE
       MakeMainfest -fileOrDirectoryPath $item -manifestPath $scriptICACLs -Verbose
    #>
        [cmdletbinding()]
        param(
            $fileOrDirectoryPath,
            $manifestPath,
            $pass2
        )
        
        foreach($file in $fileOrDirectoryPath){
            $Acls = Get-Acl -Path $File 
            
    
            if($acls.Access.Count -gt 9){
                Write-Verbose "$($file) has too many acls" -Verbose
                $file | out-file $pass2 -Append -Encoding ascii
                continue
            }
            ForEach ($Acl in $Acls.Access) {
                
                if($Acl.IsInherited -eq $true){ 
                
                continue
                }
             
                if(($Acl.IdentityReference -like "staff\*" -or $Acl.IdentityReference -like "student\*" ) -and $Acl.IdentityReference -notmatch "^STAFF\\\w{2}\.\d{6}[A-Z|a-z|0-9]$"){
                    
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
    
                    if((Get-Item -Path $file).Attributes -eq "Directory"){
                        Write-Host "$($file) is a directory" -ForegroundColor Magenta
                        $access = "(OI)(CI)({0})" -f $accessLetter
                        'icacls --% "{0}" /grant "{1}":{2}' -f $file, $acl.IdentityReference, $access | Out-File $manifestPath -Append -Encoding ascii
                        
    
                
                    }else{
                        Write-Host "$($file) is a file" -ForegroundColor yellow
                        'icacls --% "{0}" /grant "{1}":({2})' -f $file, $acl.IdentityReference, $accessLetter | Out-File $manifestPath -Append -Encoding ascii
                    }
            
                }
            }
        }
     }
    
    
    
    $scriptICACLs = "c:\temp\Manifest_Pass1.ps1"
    $pass2 = "c:\temp\pass2.txt"
    
    
        
     $dirs = Get-Content C:\temp\dirs.txt
    foreach($dir in $dirs){
        Write-Host $dir -ForegroundColor Magenta
        $items = (Get-ChildItem $Dir -Recurse -ErrorAction SilentlyContinue).FullName
    
        foreach($item in $items){
            Write-Host $item -ForegroundColor Green
            MakeMainfest -fileOrDirectoryPath $item -manifestPath $scriptICACLs -pass2 $pass2 -Verbose
        }
    
    }
    
    
    Break;
    $scriptICACLs = "c:\temp\Manifest_HLTH_Pass1_Link.ps1"
    $pass2 = "c:\temp\pass2_HLTH_Link.txt"
    
    $dirs = Get-Content C:\Temp\HLTHdirs.txt
    foreach($dir in $dirs){
        Write-Host $dir -ForegroundColor Magenta
        $items = (Get-ChildItem $Dir -Recurse -ErrorAction SilentlyContinue).FullName
    
        foreach($item in $items){
            Write-Host $item -ForegroundColor Green
            MakeMainfest -fileOrDirectoryPath $item -manifestPath $scriptICACLs -pass2 $pass2 -Verbose
        }
    
    }
    