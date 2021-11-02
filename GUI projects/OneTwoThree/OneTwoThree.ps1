Add-Type -AssemblyName PresentationFramework


[xml]$myXaml = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"        
        Title="One Two Three" Height="450" Width="800">
    <Grid>
        <Button Name="btnOne" Content="Step 1" HorizontalAlignment="Left" Height="111" Margin="30,26,0,0" VerticalAlignment="Top" Width="242"/>
        <Button Name="btnTwo" Content="Step 2" HorizontalAlignment="Center" Height="111" Margin="16,26,0,0" VerticalAlignment="Top" Width="242" IsEnabled="False"/>
        <Button Name="btnThree" Content="Step 3" HorizontalAlignment="Left" Height="111" Margin="528,26,0,0" VerticalAlignment="Top" Width="242" IsEnabled="False"/>
        <Label Name="lblFinished" Content="" HorizontalAlignment="Left" Height="50" Margin="203,188,0,0" VerticalAlignment="Top" Width="377"/>

    </Grid>
</Window>
"@

$NR = (New-Object system.xml.xmlnodeReader $myXaml)
$win =[Windows.markup.xamlreader]::Load($NR)

$btnOne = $Win.FindName("btnOne")
$btnTwo = $win.FindName("btnTwo")
$btnThree = $win.FindName("btnThree")
$lblFinished = $win.FindName("lblFinished")

$btnOne.Add_Click({
    #[System.Windows.MessageBox]::Show("Step1 completed.", "Completed")
    $btnTwo.IsEnabled = $true
    $btnOne.IsEnabled = $false
})

$btnTwo.Add_Click({
    $btnThree.IsEnabled = $true
    $btnTwo.IsEnabled = $false
})

$btnThree.add_click({
    $lblFinished.content = "Finished"
    $lblFinished.Background = "Green"
    $lblFinished.FontSize = 32
    $lblFinished.FontWeight = "Bold"

})


###########Last line of code#########
$win.showdialog()

break
###################################
#First step create a click event for btnOne that enables btnTwo and disables btnOne