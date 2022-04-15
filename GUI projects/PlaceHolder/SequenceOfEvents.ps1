#region functions

#endregion

Add-Type -AssemblyName PresentationFramework

[xml]$Form = @"
    <Window xmlns ="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="My First Form" Height="480" Width="640">
    <Grid>        
        <Label Name="lbl1" Content="First Name" HorizontalAlignment="Left" Height="24" Margin="21,30,0,0" VerticalAlignment="Top" Width="200"/>
        <TextBox Name="firstName" HorizontalAlignment="Left" Height="24" Margin="138,30,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="139"/>
        <Label Name='lbl2' Content="Last Name" HorizontalAlignment="Left" Height="24" Margin="21,77,0,0" VerticalAlignment="Top" Width="200"/>
        <TextBox Name="lastName" HorizontalAlignment="Left" Height="24" Margin="138,77,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="139"/>
        <Button Name="createEmail" Content="Create Email" HorizontalAlignment="Left" Height="51" Margin="21,158,0,0" VerticalAlignment="Top" Width="138"/>
        <Button Name="emailSup" Content="Button" HorizontalAlignment="Left" Height="51" Margin="176,158,0,0" VerticalAlignment="Top" Width="138" IsEnabled="False"/>
        <Button Name="password" Content="Button" HorizontalAlignment="Left" Height="51" Margin="346,158,0,0" VerticalAlignment="Top" Width="138" IsEnabled="False"/>
        <Label Name="lbl3" Content="" HorizontalAlignment="Left" Height="34" Margin="21,300,0,0" VerticalAlignment="Top" Width="300"/>
    </Grid>
    </Window>
"@

$NR = (New-Object system.xml.xmlnodeReader $Form)
$win =[Windows.markup.xamlreader]::Load($NR)
#region assign variables
    $btnOne = $Win.FindName("createEmail")
    $firstName = $win.FindName("firstName")
    $lastName = $win.FindName("lastName")
    $btnTwo = $win.FindName("emailSup")
    $btnThree = $win.FindName("password")
    [string]$email
    $lbl1 = $win.FindName("lbl1")
    $lbl2 = $win.FindName("lbl2")
    $lbl3 = $win.FindName("lbl3")

#endregion

#region buttons
$btnOne.add_click({
    #Creates email from first name and last name
    $email = $firstName.text + $lastName.text + "@Company.pri"
    #[System.Windows.MessageBox]::Show($email, "Email")
    $lbl3.content = $email
    $btnTwo.isEnabled = $true
    $btnOne.IsEnabled = $false
    $firstName.Clear()
    $lastName.Clear()
    $lbl1.Content = "Supervisors Name"
    $lbl2.Content = "Supervisors Email"

})
$btnTwo.add_click({
    $email = $lbl3.content
    [System.Windows.MessageBox]::Show($email, "Email")
})
$btnThree.add_click({
    [System.Windows.MessageBox]::Show("test", "Email")
})
#endregion


#Last Line
$win.showdialog()

break;
[System.Windows.MessageBox]::Show("test", "test")