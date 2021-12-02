#region functions
function hide-boxes {
    $lbl1.Opacity=0
    $lbl2.Opacity=0
    $lbl3.Opacity=0
    $lbl4.Opacity=0
    $lbl5.Opacity=0
    $txt1.Opacity=0
    $txt2.Opacity=0
    $txt3.Opacity=0
    $txt4.Opacity=0
    $txt5.Opacity=0
    $txt6.Opacity=0
    $txt7.Opacity=0
    $lbl6.Opacity=0
    $lbl7.Opacity=0
    $btnQ1.Opacity=0
    $btnQ2.Opacity=0
    $btnQ3.Opacity=0
    $btnQ4.Opacity=0
    $btnQ5.Opacity=0
    $btnQ6.Opacity=0
    $btnQ7.Opacity=0
    $chkB1.Opacity=0
    $chkB2.Opacity=0
    $chkB3.Opacity=0
    $chkB4.Opacity=0
    $chkB5.Opacity=0
    $chkB6.Opacity=0
    $chkB7.Opacity=0
}

#endregion

Add-Type -AssemblyName PresentationFramework

[xml]$Form = @"
    <Window xmlns ="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Title="Create Resource" Height="550" Width="800">
    <Grid Background="#FF93E9F7">
        <ComboBox Name="cboResourses" HorizontalAlignment="Left" Height="45" Margin="31,36,0,0" VerticalAlignment="Top" Width="267" Cursor="" FontSize="16"/>
        <Label Content="Select Resourse" HorizontalAlignment="Left" Height="27" Margin="35,4,0,0" VerticalAlignment="Top" Width="263" FontSize="16"/>
        <Label Name="lbl1" Content="Label" HorizontalAlignment="Left" Height="40" Margin="35,105,0,0" VerticalAlignment="Top" Width="263" />
        <Label Name="lbl2" Content="Label" HorizontalAlignment="Left" Height="40" Margin="35,164,0,0" VerticalAlignment="Top" Width="263" />
        <Label Name="lbl3" Content="Label" HorizontalAlignment="Left" Height="40" Margin="35,217,0,0" VerticalAlignment="Top" Width="263" />
        <Label Name="lbl4" Content="Label" HorizontalAlignment="Left" Height="40" Margin="35,281,0,0" VerticalAlignment="Top" Width="263"/>
        <Label Name="lbl5" Content="Label" HorizontalAlignment="Left" Height="40" Margin="35,342,0,0" VerticalAlignment="Top" Width="267" />
        <Label Name="lbl6" Content="Label" HorizontalAlignment="Left" Height="40" Margin="35,401,0,0" VerticalAlignment="Top" Width="263"/>
        <Label Name="lbl7" Content="Label" HorizontalAlignment="Left" Height="40" Margin="35,460,0,0" VerticalAlignment="Top" Width="267" />
        <Button Name="btnCopy" Content="Copy Resource" HorizontalAlignment="Left" Height="45" Margin="332,36,0,0" VerticalAlignment="Top" Width="167"/>
        <Button Name="btnHelp" Content="Help" HorizontalAlignment="Left" Height="45" Margin="523,36,0,0" VerticalAlignment="Top" Width="165"/>
        <TextBox Name="txt1" HorizontalAlignment="Left" Height="40" Margin="343,105,0,0" Text="TextBox" TextWrapping="Wrap" VerticalAlignment="Top" Width="311"/>
        <TextBox Name="txt2" HorizontalAlignment="Left" Height="40" Margin="343,164,0,0" Text="TextBox" TextWrapping="Wrap" VerticalAlignment="Top" Width="311"/>
        <TextBox Name="txt3" HorizontalAlignment="Left" Height="40" Margin="343,217,0,0" Text="TextBox" TextWrapping="Wrap" VerticalAlignment="Top" Width="311"/>
        <TextBox Name="txt4" HorizontalAlignment="Left" Height="40" Margin="343,281,0,0" Text="TextBox" TextWrapping="Wrap" VerticalAlignment="Top" Width="311"/>
        <TextBox Name="txt5" HorizontalAlignment="Left" Height="40" Margin="343,342,0,0" Text="TextBox" TextWrapping="Wrap" VerticalAlignment="Top" Width="311"/>
        <TextBox Name="txt6" HorizontalAlignment="Left" Height="40" Margin="343,401,0,0" Text="TextBox" TextWrapping="Wrap" VerticalAlignment="Top" Width="311"/>
        <TextBox Name="txt7" HorizontalAlignment="Left" Height="40" Margin="343,460,0,0" Text="TextBox" TextWrapping="Wrap" VerticalAlignment="Top" Width="311"/>
        <Button Name="btnQ1" Content="?" HorizontalAlignment="Left" Height="40" Margin="670,105,0,0" VerticalAlignment="Top" Width="42"/>
        <Button Name="btnQ2" Content="?" HorizontalAlignment="Left" Height="40" Margin="670,164,0,0" VerticalAlignment="Top" Width="42"/>
        <Button Name="btnQ3" Content="?" HorizontalAlignment="Left" Height="40" Margin="670,217,0,0" VerticalAlignment="Top" Width="42"/>
        <Button Name="btnQ4" Content="?" HorizontalAlignment="Left" Height="40" Margin="670,281,0,0" VerticalAlignment="Top" Width="42"/>
        <Button Name="btnQ5" Content="?" HorizontalAlignment="Left" Height="40" Margin="670,342,0,0" VerticalAlignment="Top" Width="42"/>
        <Button Name="btnQ6" Content="?" HorizontalAlignment="Left" Height="40" Margin="670,401,0,0" VerticalAlignment="Top" Width="42"/>
        <Button Name="btnQ7" Content="?" HorizontalAlignment="Left" Height="40" Margin="670,460,0,0" VerticalAlignment="Top" Width="42"/>
        <CheckBox Name="chkB1" Content="Include" HorizontalAlignment="Left" Height="20" Margin="717,115,0,0" VerticalAlignment="Top" Width="62" RenderTransformOrigin="0.069,1.075"/>
        <CheckBox Name="chkB2" Content="Include" HorizontalAlignment="Left" Height="20" Margin="717,164,0,0" VerticalAlignment="Top" Width="62" RenderTransformOrigin="0.069,1.075"/>
        <CheckBox Name="chkB3" Content="Include" HorizontalAlignment="Left" Height="20" Margin="717,227,0,0" VerticalAlignment="Top" Width="62" RenderTransformOrigin="0.069,1.075"/>
        <CheckBox Name="chkB4" Content="Include" HorizontalAlignment="Left" Height="20" Margin="717,291,0,0" VerticalAlignment="Top" Width="62" RenderTransformOrigin="0.069,1.075"/>
        <CheckBox Name="chkB5" Content="Include" HorizontalAlignment="Left" Height="20" Margin="717,352,0,0" VerticalAlignment="Top" Width="62" RenderTransformOrigin="0.069,1.075"/>
        <CheckBox Name="chkB6" Content="Include" HorizontalAlignment="Left" Height="20" Margin="717,411,0,0" VerticalAlignment="Top" Width="62" RenderTransformOrigin="0.069,1.075"/>
        <CheckBox Name="chkB7" Content="Include" HorizontalAlignment="Left" Height="20" Margin="717,471,0,0" VerticalAlignment="Top" Width="62" RenderTransformOrigin="0.069,1.075"/>
    </Grid>
    </Window>
"@

$NR = (New-Object system.xml.xmlnodeReader $Form)
$win =[Windows.markup.xamlreader]::Load($NR)


#region assign variables

$cboResourses = $win.FindName("cboResourses")
$lbl1 = $win.FindName("lbl1")
$lbl2 = $win.FindName("lbl2")
$lbl3 = $win.FindName("lbl3")
$lbl4 = $win.FindName("lbl4")
$lbl5 = $win.FindName("lbl5")
$lbl6 = $win.FindName("lbl6")
$lbl7 = $win.FindName("lbl7")
$txt1 = $win.FindName("txt1")
$txt2 = $win.FindName("txt2")
$txt3 = $win.FindName("txt3")
$txt4 = $win.FindName("txt4")
$txt5 = $win.FindName("txt5")
$txt6 = $win.FindName("txt6")
$txt7 = $win.FindName("txt7")
$btnCopy = $win.FindName("btnCopy")
$btnHelp = $win.FindName("btnHelp")
$btnQ1 = $win.FindName("btnQ1")
$btnQ2 = $win.FindName("btnQ2")
$btnQ3 = $win.FindName("btnQ3")
$btnQ4 = $win.FindName("btnQ4")
$btnQ5 = $win.FindName("btnQ5")
$btnQ6 = $win.FindName("btnQ6")
$btnQ7 = $win.FindName("btnQ7")
$chkB1 = $win.FindName("chkB1")
$chkB2 = $win.FindName("chkB2")
$chkB3 = $win.FindName("chkB3")
$chkB4 = $win.FindName("chkB4")
$chkB5 = $win.FindName("chkB5")
$chkB6 = $win.FindName("chkB6")
$chkB7 = $win.FindName("chkB7")

#endregion

#Populate the combo box

$cboResourses.Items.Add("File")
$cboResourses.Items.Add("Group")
$cboResourses.Items.Add("User")
$cboResourses.Items.Add("WindowsFeature")
$cboResourses.Items.Add("Registry")
hide-boxes

#region buttons
$cboResourses.add_SelectionChanged({
    $resource = $cboResourses.SelectedValue
    switch($cboResourses.SelectedValue){
        
        "File"{
            hide-boxes
            $lbl1.Opacity=100
            $lbl1.Content="DestinationPath"
            $lbl1.Background="Green"
            $txt1.Opacity=100
            $txt1.Text="[String]"
            $btnQ1.Opacity=100
            $chkB1.Opacity=100
            $chkB1.IsChecked=$true
            $chkB1.IsEnabled=$false            

            $lbl2.Background="Yellow"
            $lbl2.Opacity=100
            $lbl2.Content="Attributes"
            $txt2.Opacity=100
            $txt2.Text="Archive | Hidden | ReadOnly | System"
            $btnQ2.Opacity=100
            $chkB2.Opacity=100
            $chkB2.IsChecked=$false

            $lbl3.Background="Yellow"
            $lbl3.Opacity=100
            $lbl3.Content="Contents"
            $txt3.Opacity=100
            $txt3.Text="[String]"
            $btnQ3.Opacity=100
            $chkB3.Opacity=100
            $chkB3.IsChecked=$false

            $lbl4.Background="Yellow"
            $lbl4.Opacity=100
            $lbl4.Content="Recurse"
            $txt4.Opacity=100
            $txt4.Text="[Bool]"
            $btnQ4.Opacity=100
            $chkB4.Opacity=100
            $chkB4.IsChecked=$false

            $lbl5.Background="Yellow"
            $lbl5.Opacity=100
            $lbl5.Content="SourcePath"
            $txt5.Opacity=100
            $txt5.Text="[String]"
            $btnQ5.Opacity=100
            $chkB5.Opacity=100
            $chkB5.IsChecked=$false

            $lbl6.Background="Yellow"
            $lbl6.Opacity=100
            $lbl6.Content="Type"
            $txt6.Opacity=100
            $txt6.Text="Directory | File"
            $btnQ6.Opacity=100
            $chkB6.Opacity=100
            $chkB6.IsChecked=$false

            $lbl7.Background="Yellow"
            $lbl7.Opacity=100
            $lbl7.Content="Ensure"
            $txt7.Opacity=100
            $txt7.Text="Absent | Present"
            $btnQ7.Opacity=100
            $chkB7.Opacity=100
            $chkB7.IsChecked=$false
        }
        "Group"{
            hide-boxes
            $lbl1.Opacity=100
            $lbl1.Content="GroupName"
            $lbl1.Background="Green"
            $txt1.Opacity=100
            $txt1.Text="[String]"
            $btnQ1.Opacity=100
            $chkB1.Opacity=100
            $chkB1.IsChecked=$true
            $chkB1.IsEnabled=$false

            $lbl2.Background="Yellow"
            $lbl2.Opacity=100
            $lbl2.Content="Description"
            $txt2.Opacity=100
            $txt2.Text="[String]"
            $btnQ2.Opacity=100
            $chkB2.Opacity=100
            $chkB2.IsChecked=$false

            $lbl3.Background="Yellow"
            $lbl3.Opacity=100
            $lbl3.Content="Ensure"
            $txt3.Opacity=100
            $txt3.Text="Absent | Present"
            $btnQ3.Opacity=100
            $chkB3.Opacity=100
            $chkB3.IsChecked=$false

            $lbl4.Background="Yellow"
            $lbl4.Opacity=100
            $lbl4.Content="Members"
            $txt4.Opacity=100
            $txt4.Text="[string[]]"
            $btnQ4.Opacity=100
            $chkB4.Opacity=100
            $chkB4.IsChecked=$false

            
        }
        "User"{
            hide-boxes
            $lbl1.Opacity=100
            $lbl1.Content="UserName"
            $lbl1.Background="Green"
            $txt1.Opacity=100
            $txt1.Text="[String]"
            $btnQ1.Opacity=100
            $chkB1.Opacity=100
            $chkB1.IsChecked=$true
            $chkB1.IsEnabled=$false

            $lbl2.Background="Yellow"
            $lbl2.Opacity=100
            $lbl2.Content="Description"
            $txt2.Opacity=100
            $txt2.Text="[String]"
            $btnQ2.Opacity=100
            $chkB2.Opacity=100
            $chkB2.IsChecked=$false

            $lbl3.Background="Yellow"
            $lbl3.Opacity=100
            $lbl3.Content="Fullname"
            $txt3.Opacity=100
            $txt3.Text="[String]"
            $btnQ3.Opacity=100
            $chkB3.Opacity=100
            $chkB3.IsChecked=$false

            $lbl4.Background="Yellow"
            $lbl4.Opacity=100
            $lbl4.Content="Password"
            $txt4.Opacity=100
            $txt4.Text="[PSCredential]"
            $btnQ4.Opacity=100
            $chkB4.Opacity=100
            $chkB4.IsChecked=$false

            $lbl5.Background="Yellow"
            $lbl5.Opacity=100
            $lbl5.Content="PasswordChangeRequired"
            $txt5.Opacity=100
            $txt5.Text="[Bool]"
            $btnQ5.Opacity=100
            $chkB5.Opacity=100
            $chkB5.IsChecked=$false

            $lbl6.Background="Yellow"
            $lbl6.Opacity=100
            $lbl6.Content="PasswordNeverExpires"
            $txt6.Opacity=100
            $txt6.Text="[Bool]"
            $btnQ6.Opacity=100
            $chkB6.Opacity=100
            $chkB6.IsChecked=$false

            $lbl7.Background="Yellow"
            $lbl7.Opacity=100
            $lbl7.Content="PasswordChangeRequired"
            $txt7.Opacity=100
            $txt7.Text="[Bool]"
            $btnQ7.Opacity=100
            $chkB7.Opacity=100
            $chkB7.IsChecked=$false
        }
        "WindowsFeature"{
            hide-boxes
            $lbl1.Opacity=100
            $lbl1.Content="Name"
            $lbl1.Background="Green"
            $txt1.Opacity=100
            $txt1.Text="[String]"
            $btnQ1.Opacity=100
            $chkB1.Opacity=100
            $chkB1.IsChecked=$true
            $chkB1.IsEnabled=$false

            $lbl2.Background="Yellow"
            $lbl2.Opacity=100
            $lbl2.Content="Ensure"
            $txt2.Opacity=100
            $txt2.Text="Absent | Present"
            $btnQ2.Opacity=100
            $chkB2.Opacity=100
            $chkB2.IsChecked=$false

            $lbl3.Background="Yellow"
            $lbl3.Opacity=100
            $lbl3.Content="IncludeAllSubFeature"
            $txt3.Opacity=100
            $txt3.Text="[Bool]"
            $btnQ3.Opacity=100
            $chkB3.Opacity=100
            $chkB3.IsChecked=$false

            $lbl4.Background="Yellow"
            $lbl4.Opacity=100
            $lbl4.Content="LogPath"
            $txt4.Opacity=100
            $txt4.Text="[String]"
            $btnQ4.Opacity=100
            $chkB4.Opacity=100
            $chkB4.IsChecked=$false

            $lbl5.Background="Yellow"
            $lbl5.Opacity=100
            $lbl5.Content="Source"
            $txt5.Opacity=100
            $txt5.Text="[String]"
            $btnQ5.Opacity=100
            $chkB5.Opacity=100
            $chkB5.IsChecked=$false
            
        }
        "Registry"{
            hide-boxes
            $lbl1.Opacity=100
            $lbl1.Content="Key"
            $lbl1.Background="Green"
            $txt1.Opacity=100
            $txt1.Text="[String]"
            $btnQ1.Opacity=100
            $chkB1.Opacity=100
            $chkB1.IsChecked=$true
            $chkB1.IsEnabled=$false

            $lbl2.Background="Green"
            $lbl2.Opacity=100
            $lbl2.Content="ValueName"
            $txt2.Opacity=100
            $txt2.Text="[String]"
            $btnQ2.Opacity=100
            $chkB2.Opacity=100
            $chkB2.IsChecked=$true
            #$chkB2.IsEnabled=$false
            

            $lbl3.Background="Yellow"
            $lbl3.Opacity=100
            $lbl3.Content="Ensure"
            $txt3.Opacity=100
            $txt3.Text="Absent | Present"
            $btnQ3.Opacity=100
            $chkB3.Opacity=100
            $chkB3.IsChecked=$false


            $lbl4.Background="Yellow"
            $lbl4.Opacity=100
            $lbl4.Content="Hex"
            $txt4.Opacity=100
            $txt4.Text="[Bool]"
            $btnQ4.Opacity=100
            $chkB4.Opacity=100
            $chkB4.IsChecked=$false

            $lbl5.Background="Yellow"
            $lbl5.Opacity=100
            $lbl5.Content="ValueData"
            $txt5.Opacity=100
            $txt5.Text="[String[]]"
            $btnQ5.Opacity=100
            $chkB5.Opacity=100
            $chkB5.IsChecked=$false

            $lbl6.Background="Yellow"
            $lbl6.Opacity=100
            $lbl6.Content="ValueType"
            $txt6.Opacity=100
            $txt6.Text="Binary | Dword | ExpandString | MultiString | Qword | String"
            $btnQ6.Opacity=100
            $chkB6.Opacity=100
            $chkB6.IsChecked=$false
        }
    }
    
})

$btnCopy.add_click({
    $t1 = $txt1.Text.trim()
    $l1 = $lbl1.content
    $t2 = $txt2.Text.trim()
    $l2 = $lbl2.content
    $t3 = $txt3.Text.trim()
    $l3 = $lbl3.content
    $t4 = $txt4.Text.trim()
    $l4= $lbl4.content
    $t5= $txt5.Text.trim()
    $l5= $lbl5.content
    $t6= $txt6.Text.trim()
    $l6= $lbl6.content
    $t7= $txt7.Text.trim()
    $l7= $lbl7.content

    # A - G represents lines 1 to 7 they are empty unless checked.
    $a = ''
    $b = ''
    $c = ''
    $d = ''
    $e = ''
    $f = ''    
    $resouce = $cboResourses.SelectedValue

    $hstring1 = "
    File $resouce
    {
    $l1 = `"$t1`""

    
    if($chkB2.IsChecked){
        $a += "$l2 `= `"$t2`""
    }
    if($chkB3.IsChecked){
        $b += "$l3 `= `"$t3`""
    }
    if($chkB4.IsChecked){
        $c += "$l4 `= `"$t4`""
    }
    if($chkB5.IsChecked){
        $d += "$l5 `= `"$t5`""
    }
    if($chkB6.IsChecked){
        $e += "$l6 `= `"$t6`""
    }
    if($chkB7.IsChecked){
        $f += "$l7 `= `"$t7`""
    }

    $hstring2 ="
    $a
    $b
    $c
    $d
    $e
    $f    
    "

    $hstring3 ="
    }
    "

    $hstring = $hstring1 + $hstring2 + $hstring3
    $hstring | clip
})

$btnHelp.add_click({
    Invoke-Item ./help.html

})

$btnQ1.add_click({
    $resource = $cboResourses.SelectedValue
    switch($cboResourses.SelectedValue){
        
        "File"{
            [System.Windows.MessageBox]::Show(
            "[String]

            Eg c:\temp

            or C:\temp\File.txt
            ", "DestinationPath")
        }
        "Group"{
            [System.Windows.MessageBox]::Show(
            "[String]

            Eg MasterUsers
            ", "GroupName")

            
        }
        "User"{
            [System.Windows.MessageBox]::Show(
                "[String]

                Eg MasterUser
                ", "UserName")
            
        }
        "WindowsFeature"{
        [System.Windows.MessageBox]::Show(
            "[String]

            Eg Web-Server
            ", "Name")
            
            
        }
        "Registry"{
        [System.Windows.MessageBox]::Show(
            "[String]

            Eg KeyName
            ", "Key")
            
        }
    }
})

$btnQ2.add_click({
    $resource = $cboResourses.SelectedValue
    switch($cboResourses.SelectedValue){
        
        "File"{
        [System.Windows.MessageBox]::Show(
            "[String[]]

            Archive | Hidden | ReadOnly | System

            
            ", "Attributes")
            
        }
        "Group"{
            [System.Windows.MessageBox]::Show(
            "[String]

            This is the master group

            
            ", "Description")

            
        }
        "User"{
            [System.Windows.MessageBox]::Show(
            "[String]

            This is the Master User

            
            ", "Description")
        }
        "WindowsFeature"{
            [System.Windows.MessageBox]::Show(
            "[String]

            Absent | Present 

            
            ", "Ensure")
            
        }
        "Registry"{
            [System.Windows.MessageBox]::Show(
            "[String]

            1

            
            ", "ValueName")
        }
    }

})

$btnQ3.add_click({
    $resource = $cboResourses.SelectedValue
    switch($cboResourses.SelectedValue){
        
        "File"{
            [System.Windows.MessageBox]::Show(
            "[String]

            Eg: Hello World!

            
            ", "Content")
        }
        "Group"{
            [System.Windows.MessageBox]::Show(
            "[String]

            Absent | Present

            
            ", "Ensure")

            
        }
        "User"{
            [System.Windows.MessageBox]::Show(
            "[String]

            Master User

            
            ", "FullName")
        }
        "WindowsFeature"{
            [System.Windows.MessageBox]::Show(
            "[Bool]

            `$True | `$False

            
            ", "IncludeAllSubFeature")
            
        }
        "Registry"{
            [System.Windows.MessageBox]::Show(
            "[String]

            Absent | Present

            
            ", "Ensure")
        }
    }

})

$btnQ4.add_click({
    $resource = $cboResourses.SelectedValue
    switch($cboResourses.SelectedValue){
        
        "File"{
            [System.Windows.MessageBox]::Show(
            "[Bool]

            `$True

            
            ", "Recurse")
        }
        "Group"{
            [System.Windows.MessageBox]::Show(
            "[String[]]

            GoodUsers, RealyGoodUsers

            
            ", "Members")

            
        }
        "User"{
            [System.Windows.MessageBox]::Show(
            "[PSCredential]

            

            
            ", "Password")
        }
        "WindowsFeature"{
            [System.Windows.MessageBox]::Show(
            "[String]

            c:\logs\log.log

            
            ", "LogPath")
            
        }
        "Registry"{
            [System.Windows.MessageBox]::Show(
            "[Bool]

            Hex = `$true

            
            ", "Hex")
        }
    }

})
$btnQ5.add_click({
    $resource = $cboResourses.SelectedValue
    switch($cboResourses.SelectedValue){
        
        "File"{
            [System.Windows.MessageBox]::Show(
            "[String]

            

            
            ", "")
        }
        "Group"{
            #blank

            
        }
        "User"{
            [System.Windows.MessageBox]::Show(
            "[Bool]

            

            
            ", "")
        }
        "WindowsFeature"{
            [System.Windows.MessageBox]::Show(
            "[String]

            

            
            ", "")
            
        }
        "Registry"{
            [System.Windows.MessageBox]::Show(
            "[String[]]

            

            
            ", "")
        }
    }

})

$btnQ6.add_click({
    $resource = $cboResourses.SelectedValue
    switch($cboResourses.SelectedValue){
        
        "File"{
            [System.Windows.MessageBox]::Show(
            "Directory | File

            

            
            ", "")
        }
        "Group"{
            #blank

            
        }
        "User"{
            [System.Windows.MessageBox]::Show(
            "[Bool]

            

            
            ", "")
        }
        "WindowsFeature"{
            #blank
            
        }
        "Registry"{
            [System.Windows.MessageBox]::Show(
            "Binary | Dword | 
            ExpandString | MultiString | 
            Qword | String            

            
            ", "")
        }
    }

})

$btnQ7.add_click({
    $resource = $cboResourses.SelectedValue
    switch($cboResourses.SelectedValue){
        
        "File"{
            [System.Windows.MessageBox]::Show(
            "Absent | Present

            

            
            ", "")
        }
        "Group"{
            #blank

            
        }
        "User"{
            [System.Windows.MessageBox]::Show(
            "[Bool]            

            
            ", "")
        }
        "WindowsFeature"{
            #blank
            

            
           
            
        }
        "Registry"{
            #blank
        }
    }

})
#endregion



#Last active line
$win.showdialog()
break;
[System.Windows.MessageBox]::Show("test", "test")