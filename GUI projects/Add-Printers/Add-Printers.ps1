#region functions

#endregion

Add-Type -AssemblyName PresentationFramework

[xml]$Form = @"
    <Window xmlns ="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="Add Printers for Site" Height="400" Width="800">
    <Grid Background="#009ED9">
        <ComboBox Name="cboSite" HorizontalAlignment="Left" Height="50" Margin="244,110,0,0" VerticalAlignment="Top" Width="278"/>
        <Button Name="btnAddPrinters" Content="Add Printers" HorizontalAlignment="Left" Height="73" Margin="244,189,0,0" VerticalAlignment="Top" Width="274" IsEnabled="False"/>

    </Grid>
    </Window>
"@

$NR = (New-Object system.xml.xmlnodeReader $Form)
$win =[Windows.markup.xamlreader]::Load($NR)
#region assign variables

$cboSite = $win.FindName("cboSite")
$btnAddPrinters = $win.FindName("btnAddPrinters")

#endregion

$cboSite.Items.Add("Brisbane")
$cboSite.Items.Add("Sydney")
$cboSite.Items.Add("Melbourne")
$cboSite.Items.Add("Canberra")



#region buttons

$cboSite.add_SelectionChanged({
    $Site = $cboSite.SelectedValue
    $btnAddPrinters.IsEnabled = $true
    
})

$btnAddPrinters.add_click({
    $site = $cboSite.Text
    [System.Windows.MessageBox]::Show($site, "The Site is")
    switch ($site)
    {
        "Sydney" {$printers = @("\\srv1\printer1",'\\srv1\printer2','\\srv1\printer3')} 
        "Melbourne" {$printers = @("\\srv2\printer1",'\\srv2\printer2','\\srv2\printer3')}
        "Brisbane" {$printers = @("\\srv3\printer1",'\\srv1\printer2','\\srv1\printer3')}
        "Canberra" {$printers = @("\\srv3\printer1",'\\srv1\printer2','\\srv1\printer3')}
        
    }
    foreach($printer in $printers){
        
        write-verbose "Add-Printer -ConnectionName $printer" -Verbose
        
        try{
            [System.Windows.MessageBox]::Show($printer, "Attempting to Add Printer")
            Add-Printer -ConnectionName $printer -ErrorAction Stop -Verbose
        }Catch{
            [System.Windows.MessageBox]::Show("The printer $printer could not be added", "Failed")
            Write-Warning "$printer could not be added" 
        }
    
    }<##>
})
#endregion


#Last Line
$win.showdialog()

break;
[System.Windows.MessageBox]::Show("test", "test")