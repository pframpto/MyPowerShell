$h1 = "<h1>Services starting with S</h1>" 
$services = Get-Service -name s* | Select-Object name,Status,DisplayName |ConvertTo-Html -Fragment -As Table -PreContent $h1 


$header = @"
    <title>S Services</title>
    <style>
        table, th, td {
            border: 1px solid black;
        }
        table{
            border-collapse: collapse;
            width: 100%;
        }
    </style>
"@
ConvertTo-Html  -Head $header -Body $services  | Out-File sservices.html 