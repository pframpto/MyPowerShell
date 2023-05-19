#Set-ACL and icals treat files and directories differently this script was used to create seperate lists of directories and files.

$items = Get-Content C:\temp\SAE\pass2.txt

foreach($item in $items){
    #Test if it is a directory and add to SAEpass2Dirs.txt
    if((Get-Item $item).Attributes -like "Directory*"){
        $item | Out-File c:\temp\SAE\SAEpass2Dirs.txt -Encoding ascii -Append
    }else{
        $item | Out-File c:\temp\sae\SAEpass2Files.txt -Encoding ascii -Append
    }
}