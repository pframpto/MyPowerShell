function invoke-SimpleCalculator {
    param(
        
        [Parameter(Mandatory)]
        
        [float]$FirstNumber,
        [Parameter(Mandatory)]
        [float]$SecondNumber,
        [Parameter(Mandatory)]
        [ValidateSet('Add','Subtract', 'Divide', 'Multiply')]        
        $Action
    )
    switch($Action){
        "Add"{$FirstNumber + $SecondNumber}
        "Subtract"{$FirstNumber - $SecondNumber}
        "Divide"{$FirstNumber / $SecondNumber}
        "Multiply"{$FirstNumber * $SecondNumber}
        Default{"Did you forget something?"}
    }
}

Invoke-Expression (Show-Command invoke-SimpleCalculator -PassThru ) -ErrorAction Ignore