$ThisDay = [datetime]::Today
#$ThisDay.ToFileTime()

$files  = Get-ChildItem "C:\dsc" -Recurse 

foreach($file in $files){
    if($file.LastWriteTime.ToFileTime() -gt $ThisDay.AddDays(-3).tofileTime()){
        Write-Host $file.FullName -BackgroundColor Green
        $file.FullName | Out-File c:\temp\RecentFiles.txt -Append -Encoding ascii
    }
    
}