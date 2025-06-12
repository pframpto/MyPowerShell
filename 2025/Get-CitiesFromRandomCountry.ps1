$Countries = Invoke-RestMethod -Uri 'https://countriesnow.space/api/v0.1/countries' -Method Get
$country = $Countries.data.country | Get-Random
(Invoke-RestMethod -Uri 'https://countriesnow.space/api/v0.1/countries/cities' -Body (@{ country = $country } |ConvertTo-Json -Compress) -Method 'post' -ContentType 'application/json').data