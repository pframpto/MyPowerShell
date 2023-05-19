$files = (get-childitem "\\Server1\shared\Here\" -depth 2 -file).FullName
"Processing"
foreach($file in $files){
    $file
    $file2 = $file.Replace("\\Server1\shared\","\\Server2\shared\")
    $file2
    if(test-path $file2){

    }else{
        Copy-Item $file -Destination $file2 -Verbose

    }

}