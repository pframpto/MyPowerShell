#region functions
   

    function install-domain($thepwd){
        Write-Verbose "trying to install ad with the parameters $theDN $theNBN and $thepwd" -Verbose
        $theNewPwd = $thepwd[0]
        $theNewDN = $thepwd[1]
        $theNewNBN = $thepwd[2]
        Import-Module ADDSDeployment
        Write-Verbose "made it past importing the module addsdeployment" -Verbose
        $param = @{'CreateDnsDelegation'=$false;
               'DatabasePath'="C:\Windows\NTDS";               
               'forestmode'='win2012r2';
               'installdns'=$true;
               'logpath'="C:\Windows\NTDS";
               'NoRebootOnCompletion'=$true;           
               'confirm'=$false           
              }

        Write-Verbose "made it past the parameter block" 
        
        
        
        Install-ADDSForest @param -SafeModeAdministratorPassword (convertTo-SecureString -AsPlainText $theNewPwd -Force ) -DomainName $theNewDN -DomainNetbiosName $theNewNBN 
        '3' | Out-File .\1.txt
         Write-Verbose "Restarting the computer" -Verbose
        Restart-Computer
    
    }
    function New-PopulateAD ($path){
    $users = import-csv $path
    try{
    New-ADOrganizationalUnit -Name "UserAccounts" -Path "DC=company,DC=pri"
    }catch{ Write-Verbose "Check if this OU already exists" -Verbose}

    foreach($user in $users){
        $name = ($user.GivenName + '.' + $user.Surname)
        $email = ($name + '@company.pri')
        $opath = "OU=UserAccounts,DC=company,DC=pri"
        New-ADUser -Name $name -AccountPassword (convertTo-SecureString -AsPlainText "P@ssw0rd" -Force )   -DisplayName $name -EmailAddress $email -GivenName $user.givename -Path $opath -SamAccountName $name -Surname $user.surname -Enabled $true 
    
    
    }
}
#endregion


Set-Location((Get-ChildItem ($MyInvocation.InvocationName)).DirectoryName)

Add-Type -AssemblyName PresentationFramework


[xml]$Form = @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"        
        Title="MainWindow" Height="450" Width="800">
    <Grid>
        <Button Name="btnInstallPreReqs" Content="Install Prerequisites" HorizontalAlignment="Left" Height="73" Margin="31,18,0,0" VerticalAlignment="Top" Width="215"/>
        <Button Name="btnInstallDomain" Content="Make Domain Controller" HorizontalAlignment="Left" Height="73" Margin="31,106,0,0" VerticalAlignment="Top" Width="215" IsEnabled="False"/>
        <Label Content="Safe mode Administrator Password" HorizontalAlignment="Left" Height="37" Margin="322,18,0,0" VerticalAlignment="Top" Width="400"/>
        <TextBox Name="txtSafeModePassword" HorizontalAlignment="Left" Height="37" Margin="322,60,0,0" Text="P@ssw0rd" TextWrapping="Wrap" VerticalAlignment="Top" Width="400" IsEnabled="False"/>
        <Label Content="Domain Name" HorizontalAlignment="Left" Height="36" Margin="322,106,0,0" VerticalAlignment="Top" Width="400"/>
        <TextBox Name="txtDomainName" HorizontalAlignment="Left" Height="38" Margin="322,142,0,0" Text="company.pri" TextWrapping="Wrap" VerticalAlignment="Top" Width="400" IsEnabled="False"/>
        <Label Content="NetBios Name" HorizontalAlignment="Left" Height="37" Margin="322,190,0,0" VerticalAlignment="Top" Width="400"/>
        <TextBox Name="txtNetBios" HorizontalAlignment="Left" Height="37" Margin="322,226,0,0" Text="company" TextWrapping="Wrap" VerticalAlignment="Top" Width="400" IsEnabled="False"/>
        <Button Name="btnPopulateAD" Content="Add Users from CSV" HorizontalAlignment="Left" Height="73" Margin="31,190,0,0" VerticalAlignment="Top" Width="215" IsEnabled="False"/>
        <Label Content="CSV File Name" HorizontalAlignment="Left" Height="37" Margin="322,268,0,0" VerticalAlignment="Top" Width="400"/>
        <TextBox Name="txtCSV" HorizontalAlignment="Left" Height="36" Margin="322,310,0,0" Text="users.csv" TextWrapping="Wrap" VerticalAlignment="Top" Width="400" IsEnabled="False"/>

    </Grid>
</Window>
"@


$NR = (New-Object system.xml.xmlnodeReader $Form)
$win =[Windows.markup.xamlreader]::Load($NR)

#region assign variables
#buttons
$preReqs = $win.FindName("btnInstallPreReqs")
$installDom = $win.FindName("btnInstallDomain")
$populate = $win.FindName("btnPopulateAD")

#text boxes
$smpwd = $win.FindName("txtSafeModePassword")
$DomanName = $win.FindName("txtDomainName")
$NetBiosName = $win.FindName("txtNetBios")
$csv = $win.FindName("txtCSV")
#endregion

$step = Get-Content ./1.txt
if($step -eq 1){
    Write-Verbose "This is the first step" -Verbose
}elseif($step -eq 3){
    $csv.isEnabled = $true
    $populate.IsEnabled = $true
    $installDom.IsEnabled = $false
    $smpwd.IsEnabled = $false
    $DomanName.IsEnabled = $false
    $NetBiosName.IsEnabled = $false
    $preReqs.IsEnabled = $false
}elseif($step -eq 2){
    $installDom.IsEnabled = $true
    $smpwd.IsEnabled = $true
    $DomanName.IsEnabled = $true
    $NetBiosName.IsEnabled = $true
}

#region Click events

$preReqs.Add_Click({
    write-verbose "The prerequisites are installing." -Verbose
    powershell.exe -executionpolicy bypass .\install-prereqs.ps1
    $installDom.IsEnabled = $true
    $smpwd.IsEnabled = $true
    $DomanName.IsEnabled = $true
    $NetBiosName.IsEnabled = $true
     write-verbose "The prerequsites have installed." -Verbose

})

$installDom.Add_Click({
    $thepwd = $smpwd.text.Trim()
    $theDN = $DomanName.text.Trim() 
    $theNBN = $NetBiosName.text.Trim()
    
    Install-Domain($thepwd,$theDN,$theNBN)
    
    $populate.IsEnabled = $true
})

$populate.Add_Click({
    $path = $csv.text.trim()
    New-PopulateAD($path)
    [System.Windows.MessageBox]::Show("The users in $path have been added", "Users added")
})

#endregion

##############################################
$win.showdialog()
###########This is the last line #############
break

#To Do
#on form load read 1.txt
#if it says 1 nothing has been done so leave the buttons as they are
#if it says 2 the prerequsites have been met and button 2 is enabled
#if it say 3 button1 and button 2 should be disabled and button3 and its textbox should be enabled.

