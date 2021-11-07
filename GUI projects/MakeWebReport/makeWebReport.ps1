$style = @"
    <style>
    body{
        text-align: center;
        background-color: aqua;
    }
    table{ 
        border-collapse:collapse;
        width:60%;
        background-color: azure;
        margin: auto;       
        
        
        
    }
    td, th{
        border:solid 1px black;
        padding:4px;
        text-align:center;
    }
    th{
        color: white;
        background-color: rgb(0,0,127)
    }
    

    tr:nth-child(even){
        background-color : lightpink;
    }
    tr:hover {background-color: yellow;}
    </style>
    <title>HTML Report</title>
"@
#region Add Functions

#endregion

Add-Type -AssemblyName PresentationFramework

[xml]$Form = @"
    <Window xmlns ="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="Make Web Report" Height="300" Width="750">
    <Grid Background="#FFE4F7D9">
        <Label Content="Computer Name" HorizontalAlignment="Left" Height="30" Margin="10,27,0,0" VerticalAlignment="Top" Width="100"/>
        <TextBox Name="txtComputer" HorizontalAlignment="Left" Height="30" Margin="110,27,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="200" Text="localhost"/>
        <Button Name="btnCheck" Content="Check it is online" HorizontalAlignment="Left" Height="30" Margin="326,27,0,0" VerticalAlignment="Top" Width="150" />
        <Button Name="btnReport" Content="Make Web Report" HorizontalAlignment="Left" Height="30" Margin="501,27,0,0" VerticalAlignment="Top" Width="150" IsEnabled="False"/>
        <CheckBox Name="chCPU" Content="Top processes by CPU" HorizontalAlignment="Left" Height="30" Margin="10,71,0,0" VerticalAlignment="Top" Width="140"/>
        <CheckBox Name="chMem" Content="Top Processes by Memory" HorizontalAlignment="Left" Height="30" Margin="172,71,0,0" VerticalAlignment="Top" Width="160"/>
        <CheckBox Name="chOptFeatures" Content="Optional Features" HorizontalAlignment="Left" Height="30" Margin="359,71,0,0" VerticalAlignment="Top" Width="117"/>
        <CheckBox Name="chPrinter" Content="Printers" HorizontalAlignment="Left" Height="30" Margin="501,71,0,0" VerticalAlignment="Top" Width="150"/>
        <Button Name="btnShowReport" Content="Show Report" HorizontalAlignment="Left" Height="30" Margin="501,140,0,0" VerticalAlignment="Top" Width="150" IsEnabled="False"/>

    </Grid>
    </Window>
"@

$NR = (New-Object system.xml.xmlnodeReader $Form)
$win =[Windows.markup.xamlreader]::Load($NR)
#region Assign variables to elements
$txtComputer = $win.FindName("txtComputer")
$btnCheck = $win.FindName("btnCheck")
$btnReport = $win.FindName("btnReport")
$chCPU = $win.FindName("chCPU")
$chMem = $win.FindName("chMem")
$chOptFeatures =$win.FindName("chOptFeatures")
$chPrinter = $win.FindName("chPrinter")
$btnShowReport = $win.FindName("btnShowReport")
#endregion

Set-Location((Get-ChildItem ($MyInvocation.InvocationName)).DirectoryName)

$btnCheck.add_click({
    if(Test-Connection -ComputerName $txtComputer.text.trim() -Quiet -Count 1){
        $btnReport.IsEnabled = $true
    }else{
        [System.Windows.MessageBox]::Show("Check your spelling and that the computer is online", "Warning Could not reach computer")
    }
})

$btnReport.add_click({
    if($chCPU.IsChecked){
        $cpu = Get-Process | Sort-Object -Property cpu -Descending | Select-Object ProcessName,CPU,ID -First 30 | ConvertTo-Html -as Table -Fragment -PreContent "<h2>Top 30 Processes By CPU</h2>"
        
    }
    if($chMem.IsChecked){
        $mem = Get-Process | Sort-Object -Property WS -Descending| select Name ,NPM, PM, WS, ID -First 30 | ConvertTo-Html -as Table -Fragment -PreContent "<h2>Top 30 Processes By Memory</h2>"
    }
    if($chOptFeatures.IsChecked){
        $optFeatures = Get-WindowsOptionalFeature -Online | where {$_.State -eq 'Enabled'} | Select-Object FeatureName  | ConvertTo-Html -as table -Fragment -PreContent "<h2>Features Enabled on Computer</h2>"
    }
    if($chPrinter.IsChecked){
        $printers = Get-WmiObject -Class win32_printer |Select-Object Location, Name, PrinterStatus, ShareName | ConvertTo-Html -as Table -Fragment -PreContent "<h2>Printers on the Computer</h2>"
    }

    $theComputer = $txtComputer.text.trim()
    $hheader = ConvertTo-Html -PreContent "<h1>Reporting on $theComputer</h1>"  
    ConvertTo-Html -Body "$hheader $cpu $mem $optFeatures $printers" -Head $style   | Out-File Report.html
    $btnShowReport.IsEnabled = $true
})
$btnShowReport.add_click({
    ii .\Report.html
})

#Last line of Code
$win.showdialog()

break;
[System.Windows.MessageBox]::Show("test", "test")