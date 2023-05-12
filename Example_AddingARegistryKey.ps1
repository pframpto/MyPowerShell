try{
    (Get-ItemProperty -Path "HKLM:\SOFTWARE\PaulsUptoStep\" -ErrorAction Stop).step 
    
}catch{
    New-Item -Path "HKLM:\SOFTWARE\" -Name "PaulsUptoStep"
}
New-ItemProperty -Path "HKLM:\SOFTWARE\PaulsUptoStep" -Name "Step" -Value "1" -PropertyType DWord -Force


break;

Remove-Item -Path "HKLM:\SOFTWARE\PaulsUptoStep"