#Requires -Version 5.1
#Requires -Modules burnttoast
    
#Install-Module burnttoast
break;
Import-Module burnttoast
New-BurntToastNotification -Text "Process has finished"

#region Example 1 Toast with splat

$splat = @{
    Text = 'Breaking news'
    Urgent = $true
}

New-BurntToastNotification @splat

#endregion

#region Example 2 adding a button with a link

$GoogleButton = New-BTButton -Content 'Google' -Arguments 'https://google.com'

$splat = @{
    Text = 'There''s a new thing on the internet!'
    Sound = 'IM'
    Button = $GoogleButton
}

New-BurntToastNotification @splat

#endregion


#region Example 3 Toast with colored buttons

$GoodButton = New-BTButton -Content 'Good News' -Arguments 'Good' -Color Green
$BadButton =  New-BTButton -Content 'Bad News' -Arguments 'Bad' -Color Red

$splat = @{
    Text = 'I''ve got news', "Which do you want first"
    
    Button = $GoodButton, $BadButton
}

New-BurntToastNotification @splat

#endregion


#region Example 4 Toast with progress bars

$Printer = 'Ground Floor'
$CyanPB = New-BTProgressBar -Status 'Cyan' -Value '0.75'
$MagentaPB = New-BTProgressBar -Status 'Magenta' -Value '0.9'
$YellowPB = New-BTProgressBar -Status 'Yellow' -Value '0.5'
$BlackPB = New-BTProgressBar -Status 'Black' -Value '0.09'


$splat = @{
    Text = "$printer low on toner"
    sound = 'Call2'
    ProgressBar = $CyanPB, $MagentaPB, $YellowPB , $BlackPB
}

New-BurntToastNotification @splat

#endregion


#region Example 5 Updating toast

$ToastSplat = @{
    Text = 'Demo Replacement',
            'This is the first example line of text'
    UniqueIdentifier = 'DemoReplace'
}

New-BurntToastNotification @ToastSplat
sleep 3
$ToastSplat['Text'][1] = 'This is the second example line of text'
New-BurntToastNotification @ToastSplat
sleep 3
$ToastSplat['Text'][1] = 'This is the third example line of text'
New-BurntToastNotification @ToastSplat

#endregion

#region Example 6 another way of updating toast

$id = 'DemoUpdate'

$DataBinding = @{
    HeadingPlaceholder = 'Demo Update'
    TextPlaceholder = 'This is the first example line of text'

}

$splat = @{
    Text = 'HeadingPlaceholder', 'TextPlaceholder'
    UniqueIdentifier = $id
    DataBinding = $DataBinding
}

New-BurntToastNotification @Splat
sleep 6
$DataBinding['TextPlaceholder'] = 'This is the second example of text'
Update-BTNotification -UniqueIdentifier $id -DataBinding $DataBinding

#endregion

#region Example 7 updating progress bar
# this example is not complete yet
$ParentBar = New-BTProgressBar -Title 'ParentTitle' -Status 'ParantStatus' -Value 'ParentValue'
$ChildBar = New-BTProgressBar -Title 'ChildTitle' -Status 'ChildStatus' -Value 'ChildValue'

$DataBinding = @{
    'ParentTitle' = 'Stream starting soon'
    'ParentStatus' = ''
    'ParentValue' = 0
    'ChildTitle' = ""
    'ChildStatus' = ""
    'ChildValue' = 0

}

$Id = 'SecondUpdateDemo'
$Text = 'Progress Bar Update Demo', 'There is two progress bars, they should be updated'

$ToastSplat = @{
    Text = $Text
    UniqueIdentifier = $Id
    ProgressBar = $ParentBar, $ChildBar
    DataBinding = $DataBinding
}

New-BurntToastNotification @ToastSplat

#. D:\Demo\Functions\Start-Progress.ps1

#Start-Process -dataBinding $DataBinding -uniqueId $id

#endregion










