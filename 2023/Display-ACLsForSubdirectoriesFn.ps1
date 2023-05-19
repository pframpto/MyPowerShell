function Show-ACLsForSubdirectory{
    param(
        $TestDir
    )
    $directorya = New-Object System.IO.DirectoryInfo($TestDir)
    $subdirectories = $directorya.GetDirectories()


    foreach($dir in $subdirectories){
        $directory = New-Object System.IO.DirectoryInfo($dir.FullName)

        $accessControl = $directory.GetAccessControl()
        $accessRules = $accessControl.GetAccessRules($true, $true, [System.Security.Principal.NTAccount])
        $dir.FullName
        $accessRules | Select-Object IdentityReference, AccessControlType, FileSystemRights, IsInherited | Format-Table -AutoSize
    }
}

Show-ACLsForSubdirectory -TestDir "C:\windows\system32\drivers\"
