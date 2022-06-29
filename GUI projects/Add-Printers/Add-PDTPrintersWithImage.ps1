<#
You can call this script with a batch file that contains the following:
=======================================================================

Powershell.exe -executionpolicy remotesigned -file .\Add-PDTPrinters.ps1
pause

=======================================================================
The circumvents the need to use certificates if you have an execution 
policy of all signed this will still work.

This script opens a dialog box so that the user can choose which site 
they are in.
I have place holder values of Brisbane Sydney Canberra and Melbourne 
but they can be changed easy enough.
There are also place holder values for the printers \\svr\printer1 etc
They can also be changed easy enough.
Add the script to a folder called called "Add printers" or something like 
that. And put the batch file in the same folder.

#>

Add-Type -AssemblyName PresentationFramework

[xml]$Form = @"
    <Window xmlns ="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="Add Printers for Site" Height="400" Width="800">
    <Grid Background="#009ED9">
        <TextBox Name="txtOut" HorizontalAlignment="Left" Height="55" Text="" Margin="244,0,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="278"/>
        <ComboBox Name="cboSite" HorizontalAlignment="Left" Height="50" Margin="244,80,0,0" VerticalAlignment="Top" Width="278"/>
        <ComboBox Name="cboPrinters" HorizontalAlignment="Left" Height="50" Margin="244,140,0,0" VerticalAlignment="Top" Width="278"/>
        <Button Name="btnAddPrinters" Content="Add Printers" HorizontalAlignment="Left" Height="60" Margin="244,200,0,0" VerticalAlignment="Top" Width="278" IsEnabled="False"/> 
        <Label Name="lblPrinting" Content="" HorizontalAlignment="Left" Height="50" Margin="244,280,0,0" VerticalAlignment="Top" Width="2278"/>
    </Grid>
    </Window>
"@

$NR = (New-Object system.xml.xmlnodeReader $Form)
$win =[Windows.markup.xamlreader]::Load($NR)
#region assign variables

$cboSite = $win.FindName("cboSite")
$cboPrinters = $win.FindName("cboPrinters")
$btnAddPrinters = $win.FindName("btnAddPrinters")
$txtOut = $win.FindName("txtOut")
$lblPrinting = $win.FindName("lblPrinting")
#endregion

$cboSite.Items.Add("Brisbane")
$cboSite.Items.Add("Sydney")
$cboSite.Items.Add("Melbourne")
$cboSite.Items.Add("Canberra")

#region add picture
    $uri = new-object system.uri("\\localhost\share\hays.png") #Also can be c:\folder\hays.png form
    $imagesource = new-object System.Windows.Media.Imaging.BitmapImage $uri 
    $imagebrush = new-object System.Windows.Media.ImageBrush  $imagesource
    $txtOut.background = $imagebrush

#endregion

#region buttons

$cboSite.add_SelectionChanged({
    $Site = $cboSite.SelectedValue
    switch ($site){
        "Sydney" {$printers = @("\\srv1\printer1",'\\srv1\printer2','\\srv1\printer3')} 
        "Melbourne" {$printers = @("\\srv2\printer1",'\\srv2\printer2','\\srv2\printer3')}
        "Brisbane" {$printers = @("\\srv3\printer1",'\\srv1\printer2','\\srv1\printer3')}
        "Canberra" {$printers = @("\\srv3\printer1",'\\srv1\printer2','\\srv1\printer3')}
        
    }
    foreach($printer in $printers){
        
        $cboPrinters.Items.Add($printer)
        
    
    }<##>
    
    
    
    $btnAddPrinters.IsEnabled = $true
    
})

$cboPrinters.add_SelectionChanged({
    $lblPrinting.Content = ""

})

$btnAddPrinters.add_click({
    $printer = $cboPrinters.Text
    [System.Windows.MessageBox]::Show("$printer is being added please click ok and expect to wait about a minute", $printer )   
    
            
    try{
                        
        Write-Verbose "Attempting to add printer $printer" -Verbose
        
        Add-Printer -ConnectionName $printer -ErrorAction Stop
        $lblPrinting.Content = "$printer has been added"
        [System.Windows.MessageBox]::Show($printer, "The following printer has been added")
    }Catch{
        #[System.Windows.MessageBox]::Show("The printer $printer could not be added", "Failed")        
        Write-Warning "$printer could not be added" 
        Write-Host $error[0]
        $lblPrinting.Content = "$printer could not be added"
    }
    
    
})
#endregion


#Last Line
$win.showdialog() | out-null 

break;
[System.Windows.MessageBox]::Show("test", "test")

