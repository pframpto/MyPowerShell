[System.Windows.MessageBox]::Show('When prompted. 
Select one or more printers 
Then click ok')
$printers = import-csv C:\temp\printers.csv | Out-GridView -Title "Select the printers you want" -PassThru


foreach($printer in $printers){
    $p = $printer.name
    Write-Verbose "Adding printer $p" -Verbose
    Add-Printer -ConnectionName $p -WhatIf
}