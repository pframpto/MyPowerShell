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
$win.showdialog()