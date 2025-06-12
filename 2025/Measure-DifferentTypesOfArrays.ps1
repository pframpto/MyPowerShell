(Measure-Command {
    $array = @()
    1..10000 | % {$array += $_}
}).TotalMilliseconds


(Measure-Command {
    $arrayList = New-Object System.Collections.ArrayList
    1..10000 | % {$arrayList.Add($_)}
}).TotalMilliseconds

(Measure-Command {
    $list = New-Object System.Collections.Generic.List[int]
    1..10000 | % { $list.Add($_)}
}).TotalMilliseconds

(Measure-Command {
    $list = New-Object System.Collections.Generic.List[object]
    1..10000 | % { $list.Add($_)}
}).TotalMilliseconds
