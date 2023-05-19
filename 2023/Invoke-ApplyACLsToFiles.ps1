#There were files detected that seemed to not have the correct number of ASE's some files did not inherit permissions from their parent.
#The script goes thru and finds the permissions on the parent folder and applies them to the file.


$files = Get-Content C:\MyScripts\JumpDrive\FilesWithLowAcls\TestTheseFiles17.txt

foreach($file in $files){
    $file
    $acls = Get-NTFSAccess -path ((Get-Item $file).DirectoryName)
    foreach($acl in $acls){
        Add-NTFSAccess -Path $file -Account $acl.account.accountname -AccessRights $acl.accessrights -AccessType Allow -InheritanceFlags $acl.inheritanceFlags -PropagationFlags $acl.PropagationFlags
    }

}