function Get-RandomColor {
    $colors = [enum]::GetValues([System.ConsoleColor])
    $randomColor = get-Random -InputObject $colors
    return $randomColor
}

while($true){
    $randomColor = Get-RandomColor
    Write-Host "Save the Kittens" -ForegroundColor $randomColor
    Start-Sleep -Seconds 1

}