Add-Type -AssemblyName PresentationFramework

[xml]$Form = @"
    <Window xmlns ="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="About Service" Height="480" Width="830">
    <Grid Background="#FF9393F7">
        <Label Content="Select Service" HorizontalAlignment="Left" Height="25" Margin="23,10,0,0" VerticalAlignment="Top" Width="200"/>
        <TextBox Name="txtService" HorizontalAlignment="Left" Height="25" Margin="23,41,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="200" Text="Bits" Background="#FFF7F6F6"/>
        <Button Name="btnGetService" Content="Query Service" HorizontalAlignment="Left" Height="50" Margin="249,20,0,0" VerticalAlignment="Top" Width="181"/>
        <CheckBox Name="cbxServiceType" Content="Service Type" HorizontalAlignment="Left" Height="20" Margin="23,85,0,0" VerticalAlignment="Top" Width="150"/>
        <CheckBox Name="cbxStartType" Content="Startup Type" HorizontalAlignment="Left" Height="20" Margin="222,85,0,0" VerticalAlignment="Top" Width="150"/>
        <Label Content="Name" HorizontalAlignment="Left" Height="25" Margin="23,137,0,0" VerticalAlignment="Top" Width="200"/>
        <Label Content="Status" HorizontalAlignment="Left" Margin="249,137,0,0" VerticalAlignment="Top" RenderTransformOrigin="0.391,-0.138" Width="200" Height="25"/>
        <Label Content="Display Name" HorizontalAlignment="Left" Height="25" Margin="477,137,0,0" VerticalAlignment="Top" Width="200"/>
        <Label Name="lblName" HorizontalAlignment="Left" Height="25" Margin="23,165,0,0" VerticalAlignment="Top" Width="200" Background="#FFE0DFDF"/>
        <Label Name="lblStatus" Content="" HorizontalAlignment="Left" Height="25" Margin="229,165,0,0" VerticalAlignment="Top" Width="200" Background="#FFE0DFDF"/>
        <Label Name="lblDisplayName" Content="" HorizontalAlignment="Left" Height="25" Margin="435,165,0,0" VerticalAlignment="Top" Width="350" Background="#FFE0DFDF"/>
        <Label Name="_1" Content="Service Type" HorizontalAlignment="Left" Height="25" Margin="23,208,0,0" VerticalAlignment="Top" Width="200"/>
        <Label Name="_2" Content="Startup Type" HorizontalAlignment="Left" Height="25" Margin="224,208,0,0" VerticalAlignment="Top" Width="200"/>
        <Label Name="lblServiceType" HorizontalAlignment="Left" Height="25" Margin="23,240,0,0" VerticalAlignment="Top" Width="200" Background="#FFE0DFDF"/>
        <Label Name="lblStartUpType" Content="" HorizontalAlignment="Left" Height="25" Margin="229,240,0,0" VerticalAlignment="Top" Width="200" Background="#FFE0DFDF"/>
        <Button Name="btnStart" Content="Start Service" HorizontalAlignment="Left" Height="55" Margin="23,293,0,0" VerticalAlignment="Top" Width="200"/>
        <Button Name="btnRestartService" Content="Restart Service" HorizontalAlignment="Left" Height="55" Margin="231,293,0,0" VerticalAlignment="Top" Width="200"/>

    </Grid>
    </Window>
"@

$NR = (New-Object system.xml.xmlnodeReader $Form)
$win =[Windows.markup.xamlreader]::Load($NR)
#region Assign Variables
$txtService = $win.FindName("txtService")
$btnQuery = $win.FindName("btnGetService")
$lblName = $win.FindName("lblName")
$lblStatus = $win.FindName("lblStatus")
$lblDisplayName = $win.FindName("lblDisplayName")
$lblServiceType = $win.FindName("lblServiceType")
$lblStartUpType = $win.FindName("lblStartUpType")
$btnStart = $win.FindName("btnStart")
$btnRestartService = $win.FindName("btnRestartService")
$cbxServiceType = $win.FindName("cbxServiceType")
$cbxStartType = $win.FindName("cbxStartType")
#endregion


$btnStart.Opacity = 0
$btnStart.IsEnabled = $false
$btnRestartService.Opacity = 0
$btnRestartService.IsEnabled = $false
#region Buttons
$btnQuery.add_click({
    $lblName.Content = (get-service $txtService.text.trim()).name
    $lblStatus.Content = (get-service $txtService.text.trim()).Status
    $lblDisplayName.Content = (get-service $txtService.text.trim()).DisplayName
    
    if($cbxStartType.IsChecked ){
        $lblStartUpType.Content = (get-service $txtService.text.trim()).StartType
    }else{
        $lblStartUpType.Content = ""
    }
    if($cbxServiceType.IsChecked){
        $lblServiceType.content = (get-service $txtService.text.trim()).ServiceType
    }else {
        $lblServiceType.content = ""
    } 
    if((get-service $txtService.text.trim()).Status -eq "Running"){
        $btnStart.Content = "Stop Service"
    }else {
        $btnStart.Content = "Start Service"
    }
    $btnStart.IsEnabled = $true 
    $btnStart.Opacity = 100
    $btnRestartService.IsEnabled = $true 
    $btnRestartService.Opacity = 100
})

$btnStart.add_click({
    $status = (get-service $txtService.text.trim()).Status
    $name = (get-service $txtService.text.trim()).name
    if($status -eq "Stopped"){
        
        [System.Windows.MessageBox]::Show("running start service on $name", "notice")
        Start-Service -Name $name
    }else {
        [System.Windows.MessageBox]::Show("Running Stop Service on $name", "notice")
        Stop-Service -Name $name
    }
})

$btnRestartService.add_click({
    $name = (get-service $txtService.text.trim()).name
    Restart-Service -Name $name
})
#endregion




#bottom line
$win.showdialog()