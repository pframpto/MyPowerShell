#region functions

#endregion

Add-Type -AssemblyName PresentationFramework

[xml]$Form = @"
    <Window xmlns ="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="My First Form" Height="480" Width="640">
    </Window>
"@

$NR = (New-Object system.xml.xmlnodeReader $Form)
$win =[Windows.markup.xamlreader]::Load($NR)
#region assign variables

#endregion

#region buttons

#endregion


#Last Line
$win.showdialog()

break;
[System.Windows.MessageBox]::Show("test", "test")