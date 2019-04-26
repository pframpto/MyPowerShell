<#
.SYNOPSIS
   This Script lists the ACE's from a given URL or Drive letter.
.DESCRIPTION
   This Script lists the Access Control Entries from a given URL or Drive letter.
   When you provide the script a file location it recurses through that file structure finding directories.
   It then displays the permissions granted to each directory.
   This informationion is caputered an a text document called c:\temp\permissions.txt
   You can specify a depth by default the depth is 1 which is the folders under the folders in the specified directory.
   a depth of zero is the folders on the current level.
.EXAMPLE
   Get-PDTFolderPermission -UNCPath "\\internal\Users\Central\" -Depth 0

   This writes the permissions of the directories below central to c:\temp\permissions.txt
.EXAMPLE
   Get-PDTFolderPermission -UNCPath c:\temp -TargetDirectoryOnly
   This displays only the permissions to the temp directory to the shell.
#>
Function Get-PDTFolderPermission {
    [CmdLetbinding()]
    param(
        [parameter(mandatory=$true)]
        [string]$UNCPath,
        [int]$Depth = 1,
        $Directory,
        $Directories,
        [switch]$TargetDirectoryOnly
    )

    if($TargetDirectoryOnly){
        $UNCPath
        (get-acl $UNCPath ).Access | Format-Table IdentityReference,FileSystemRights
    }Else{
        if(Test-Path c:\temp\Permissions.txt){
            Remove-Item c:\temp\Permissions.txt -Force -Confirm:$false -Verbose
        }
        New-Item -Path c:\temp\Permissions.txt -ItemType File
        Write-Verbose "Collecting a list of directories"
        $Directories = (Get-ChildItem $UNCPath -Depth $Depth -Directory -ErrorAction SilentlyContinue -Verbose).FullName
        Write-Verbose "Processing each Directory in Directories"
        foreach($Directory in $Directories){
        Write-Verbose "Working on Directory $Directory"
        $Directory | out-file c:\temp\Permissions.txt -Append
        (get-acl $Directory -ErrorAction SilentlyContinue -Verbose).Access |Format-Table IdentityReference,FileSystemRights -ErrorAction SilentlyContinue | out-file c:\temp\Permissions.txt -Append

        }
    }#End else

}

Get-PDTFolderPermission -UNCPath "S:\Workgroup\Core_Infrastructure\Operations"  -Verbose





