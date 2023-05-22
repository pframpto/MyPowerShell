$OutPutPath = "c:\temp\vc\tooManyAcls.txt"
$testDirs = (Get-ChildItem "\\Server\Share\ReallyBigFolder" -Recurse -Directory).fullName
foreach($dir in $testDirs){
    
        Write-Verbose $dir -Verbose
        if((Get-NTFSAccess -Path $dir).count -gt 9){
            $dir | out-file $pathF -encoding ascii -append
            (Get-NTFSAccess -Path $dir).count | out-file $OutPutPath -encoding ascii -append
            Get-NTFSAccess -Path $dir | Format-Table Account, InheritedFrom | out-file $OutPutPath -Encoding ascii -Append
        }
    
}
