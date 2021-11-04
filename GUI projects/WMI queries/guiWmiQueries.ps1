Add-Type -AssemblyName PresentationFramework

[xml]$Form = @"
    <Window xmlns ="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="My First Form" Height="480" Width="800">
    <Grid Background="#FF9393F7">
        <Label Content="Computer Name" HorizontalAlignment="Left" Height="38" Margin="44,26,0,0" VerticalAlignment="Top" Width="231"/>
        <TextBox Name="txtComputername" HorizontalAlignment="Left" Height="38" Margin="44,64,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="231" Text="LocalHost"/>
        <Button Name="btnQuery" Content="WMI Query" HorizontalAlignment="Left" Height="76" Margin="413,26,0,0" VerticalAlignment="Top" Width="275"/>
        <RadioButton Name="rdoBios" Content="BIOS" HorizontalAlignment="Left" Height="35" Margin="44,122,0,0" VerticalAlignment="Top" Width="116"/>
        <RadioButton Name="rdoLogicalDisk" Content="Logical Disk" HorizontalAlignment="Left" Height="35" Margin="181,122,0,0" VerticalAlignment="Top" Width="104"/>
        <RadioButton Name="rdoPrinter" Content="Printer" HorizontalAlignment="Left" Height="35" Margin="314,122,0,0" VerticalAlignment="Top" Width="104"/>
        <RadioButton Name="rdoProcessor" Content="Processor" HorizontalAlignment="Left" Height="35" Margin="444,122,0,0" VerticalAlignment="Top" Width="104"/>
        <RadioButton Name="rdoTimeZone" Content="TimeZone" HorizontalAlignment="Left" Height="35" Margin="575,122,0,0" VerticalAlignment="Top" Width="104"/>
        <DataGrid Name="dtaGrid" HorizontalAlignment="Left" Height="262" Margin="44,162,0,0" VerticalAlignment="Top" Width="635"/>

    </Grid>
    </Window>
"@

$NR = (New-Object system.xml.xmlnodeReader $Form)
$win =[Windows.markup.xamlreader]::Load($NR)
#region assign variables
$txtComputername = $win.FindName("txtComputername")
$btnQuery = $win.FindName("btnQuery")
$rdoBios = $win.FindName("rdoBios")
$rdoLogicalDisk = $win.FindName("rdoLogicalDisk")
$rdoPrinter = $win.FindName("rdoPrinter")
$rdoProcessor = $win.FindName("rdoProcessor")
$rdoTimeZone = $win.FindName("rdoTimeZone")
$dtaGrid= $win.FindName("dtaGrid")
#endregion

$btnQuery.add_click({
    
    if($rdoBios.IsChecked){
        $txtComputername = $win.FindName("txtComputername").text.trim()
        $result = Get-WmiObject -Class win32_bios -ComputerName $txtComputername | Select-Object SMBIOSBIOSVersion, Manufacturer, Name, SerialNumber, Version
        $dtaGrid.ItemsSource=@($result)
    }
    if($rdoLogicalDisk.IsChecked){
        $txtComputername = $win.FindName("txtComputername").text.trim()
        $result = Get-WmiObject -Class win32_logicaldisk -ComputerName $txtComputername| select-object DeviceID,DriveType,@{Name='FreeSpace(GB)'; e={  "{0:n2}" -f ($_.Freespace / 1gb)}}, @{name='Size(GB)';Expression={"{0:n2}" -f ($_.Size / 1gb)}}
        $dtaGrid.ItemsSource=@($result)
        
    }
    if($rdoPrinter.IsChecked){
        $txtComputername = $win.FindName("txtComputername").text.trim()
        $result = Get-WmiObject -Class win32_printer -ComputerName $txtComputername | select Location,Name,SystemName,ShareName
        $dtaGrid.ItemsSource=@($result)
    }
    if($rdoProcessor.IsChecked){
        $txtComputername = $win.FindName("txtComputername").text.trim()
        $result = Get-WmiObject -Class win32_processor -ComputerName $txtComputername | select caption,DeviceID,Manufacturer,MaxClockSpeed,Name,SocketDesignation
        $dtaGrid.ItemsSource=@($result)
    }
    if($rdoTimeZone.IsChecked){
        $txtComputername = $win.FindName("txtComputername").text.trim()
        $result = Get-WmiObject -Class win32_Timezone -ComputerName $txtComputername | select Bias, SettingID, Caption
        $dtaGrid.ItemsSource=@($result)
    }


})
<# 
$txtComputername.add_lostfocus({
    if(Test-Connection -ComputerName $txtComputername.Text.trim() -Count 1 ){}else{
        [System.Windows.MessageBox]::Show("the computer may not be available", "test")
    }
})
#>#lost focus

#Bottom of Script
$win.showdialog()
break;
[System.Windows.MessageBox]::Show("test", "test")