#This script will query services starting with s and output the results to a html table
$head = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
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
</head>
<body>
    <h1>Services begining with S</h1>
    <table>
        <tr>
            <th>Status</th>
            <th>Name</th>
            <th>Display Name</th>
        </tr>
"@
$footer = @"
</table>
    
</body>
</html>
"@
$head | out-file index.html -Encoding  ascii
$services = Get-Service -name s*
foreach($service in $services){
    $status = $service.Status
    $name = $service.Name
    $displayName = $service.DisplayName
    #New table row
    "<tr>" | Out-File index.html -Append
    "   <td>$status</td>" |Out-File index.html -Append
    "   <td>$name</td>" |Out-File index.html -Append
    "   <td>$displayname</td>" |Out-File index.html -Append
    "</tr>" | Out-File index.html -Append
}



$footer | Out-File index.html -Append