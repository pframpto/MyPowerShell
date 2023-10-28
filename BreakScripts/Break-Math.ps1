break;

([math].GetMembers()).Name | select -Unique

<#
IEEERemainder
Max
Min
Cos
Sin
Log
Exp
Pow
Ceiling
Floor
Round
Truncate
Abs
Sign
BigMul
DivRem
Acos
Asin
Atan
Atan2
Cosh
Tan
Sinh
Tanh
Sqrt
Log10
Equals
GetHashCode
GetType
ToString
PI
E
#>

[math]::pi #3.14159265358979

[math]::pow(3,2) # 3^2

[math]::Sqrt(144) # square root of 144 so 12

$n = 567.3456
[math]::Truncate($n) #removes the decimal places

[math]::Round($n,2) #will round to 2 decimal places

$n -as [int]

dir $env:temp -file -Recurse | measure-object length -sum | select count, @{Name = "SumMb";Expression= {[math]::round($_.sum/1mb,3)}}

