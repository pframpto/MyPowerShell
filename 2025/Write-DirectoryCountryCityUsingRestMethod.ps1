$data = (Invoke-RestMethod -uri 'https://countriesnow.space/api/v0.1/countries/population/cities').data


foreach($item in $data){
    if($item.country -match '\d\d'){continue}
    if($item.country -match 'footnoteSeqID'){continue}
    $dir = 'c:\countries\{0}\{1}' -f $item.country, $item.city
    try{
        mkdir -Path $dir -ErrorAction Stop
    }catch{
        Write-Warning $dir 
    }
}


