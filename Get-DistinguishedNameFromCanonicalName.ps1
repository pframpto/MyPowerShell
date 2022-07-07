Function Get-DNFromCName {
    [cmdletbinding()]
    param(
        $canonicalName
    )

    $cns = $canonicalName.Split('/')
    $countOfbits = $csn.count - 1
    $lastBit = $cns[$countOfbits]

    (Get-ADUser -Filter {name -eq $lastBit}).distinguishedname
}

Get-DNFromCName -canonicalName "company.pri/NSW/chris.apperley"

