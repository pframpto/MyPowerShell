Add-Type -AssemblyName PresentationFramework

[xml]$Form = @"
    <Window xmlns ="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="My First Form" Height="480" Width="800">
    <Grid Background="#FF93E9F7">
        <Label Content="Enter a number between 1 and 20" HorizontalAlignment="Left" Height="38" Margin="27,23,0,0" VerticalAlignment="Top" Width="346" FontSize="20"/>
        <TextBox Name="txtGuess" HorizontalAlignment="Left" Height="38" Margin="400,23,0,0" TextWrapping="Wrap" VerticalAlignment="Top" Width="78" FontSize="20"/>
        <Button Name="btnGuess" Content="Guess" HorizontalAlignment="Left" Height="38" Margin="509,23,0,0" VerticalAlignment="Top" Width="182" FontSize="20"/>
        <Label Name="lblHigherOrLower" Content="" HorizontalAlignment="Left" Height="61" Margin="27,85,0,0" VerticalAlignment="Top" Width="451" Background="Yellow" FontSize="24"/>
        <Label Name="lblResult" Content="" HorizontalAlignment="Left" Height="61" Margin="27,172,0,0" VerticalAlignment="Top" Width="700" Background="Green" FontSize="24"/>
        <Button Name="btnReset" Content="Reset" HorizontalAlignment="Left" Height="42" Margin="509,275,0,0" VerticalAlignment="Top" Width="182" FontSize="20"/>
        <Label Name="lblCount" Content="0" HorizontalAlignment="Left" Height="38" Margin="27,2,0,0" VerticalAlignment="Top" Width="346" FontSize="2"/>
        <Label Name="lblMyGuess" Content="0" HorizontalAlignment="Left" Height="38" Margin="27,3,0,0" VerticalAlignment="Top" Width="346" FontSize="2"/>

    </Grid>
    </Window>
"@

$NR = (New-Object system.xml.xmlnodeReader $Form)
$win =[Windows.markup.xamlreader]::Load($NR)
#region Variables
$txtGuess = $win.FindName("txtGuess")
$btnGuess = $win.FindName("btnGuess")
$lblHigherOrLower = $win.FindName("lblHigherOrLower")
$lblResult = $win.FindName("lblResult")
$btnReset = $win.FindName("btnReset")
$lblCount = $win.FindName("lblCount")
$lblMyGuess = $win.FindName("lblMyGuess")
#endregion

$lblHigherOrLower.Background="#FF93E9F7"
$lblResult.Background="#FF93E9F7"
$lblMyGuess.content = Get-Random -Maximum 20 -Minimum 1
 


#region Buttons




$btnGuess.add_click({
    [int]$myGuess = $lblMyGuess.content
    
    try{
        [int]$YourGuess = $txtGuess.Text
        if(($YourGuess -gt 20) -or ($YourGuess -lt 1)){
            
            [System.Windows.MessageBox]::Show("Please Enter a number between 1 and 20", "Enter a number between 1 and 20")
            
        }
    }catch{
            [System.Windows.MessageBox]::Show("Please Enter a number between 1 and 20", "Enter a number between 1 and 20")
           
    }

    $lblCount.Content = [int]$lblCount.Content + 1
    if($YourGuess -eq $myGuess){
        if([int]$lblCount.Content -lt 6){
            $lblResult.Content = "Congratulations you got it right. It took you $($lblCount.content) guesses!"
            $lblResult.Background="Green"
            $lblHigherOrLower.Content=""
            $lblHigherOrLower.Background="#FF93E9F7"
        }elseif([int]$lblCount.Content -ge 6){
            $lblResult.Content = "You took $($lblCount.content) guesses! Better luck next time"
            $lblResult.Background="Red"
            $lblHigherOrLower.Content=""
            $lblHigherOrLower.Background="#FF93E9F7"
        }
            
                            
    }
    elseif($YourGuess -gt $myGuess){
        $lblHigherOrLower.Content = "Lower"
        $lblHigherOrLower.Background = "Yellow"
            
    }elseif($YourGuess -lt $myGuess){
        $lblHigherOrLower.Content = "Higher"
        $lblHigherOrLower.Background = "Magenta"
            
    }







    #$lblHigherOrLower.Content = $lblCount.Content 
       
})



$btnReset.add_click({
    $lblMyGuess.content = Get-Random -Maximum 20 -Minimum 1
    #$win.Title = $lblMyGuess.content
    
    $txtGuess.Clear()
    $lblHigherOrLower.Content=""
    $lblResult.Content=""
    $lblHigherOrLower.Background="#FF93E9F7"
    $lblResult.Background="#FF93E9F7"
    $lblCount.Content = '0'
})
#endregion



#Last line of code.
$win.showdialog()

break;
[System.Windows.MessageBox]::Show("test", "test")