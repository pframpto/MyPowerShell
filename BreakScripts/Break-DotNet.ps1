break;

#region recursion
Get-ChildItem c:\temp -Recurse | Select-Object FullName

Measure-Command -Expression {
    [System.IO.Directory]::GetDirectories("c:\temp", "*", [System.IO.SearchOption]::AllDirectories)
}
Measure-Command -Expression {
    [System.IO.Directory]::EnumerateDirectories("C:\temp")
}

#get directories at a set length
$dirs = @('c:\temp\')
$depth = 2
for ($i = 0; $i -lt $depth; $i++) {
    $dirs = foreach ($dir in $dirs) {
        [System.IO.Directory]::EnumerateDirectories($dir)
    }
}
$dirs

#files and directories
$filesAndDirectories = [System.IO.Directory]::GetFileSystemEntries("c:\temp")
$filesAndDirectories

#just files
[System.IO.Directory]::EnumerateFiles("C:\temp")

$dir = @('c:\temp\')

$dirs = [System.IO.Directory]::EnumerateFiles($dir)
$dirs
#get files at a certain depth.
$dirs = @('c:\temp\')
$depth = 3
for ($i = 0; $i -lt $depth; $i++) {
    $dirs = foreach ($dir in $dirs) {
        [System.IO.Directory]::EnumerateDirectories($dir)
        
    }
}
#$dirs
foreach($file in $dirs){
    
    [System.IO.Directory]::EnumerateFiles($file)
}

#endregion

#region array types
    #list array
    [system.collections.Arraylist]$myArray = @()
    1..20 | ForEach-Object {$myArray.add($_)}

    #generic list
    $results = [System.Collections.Generic.List[object]]::new() 
    1..20 | ForEach-Object {$results.add($_)}

    #hash arrays
    $set = [System.Collections.Generic.HashSet[string]]::new()
    # Members are unique
    $members = "Australia","New Zealand","England","France","Japan","Thailand","Australia","Japan"
    foreach($member in $members){
        $set.Add($member)
    }
    
<#
using namespace System.Collections.Generic

$myList = [List[string]]::new()

"hit","miss","next","word" | % {$myList.Add($_)}

break;

#you can cast an existing array into a list like this
$existingArray = 1..5
$fromArray = [List[int]]$existingArray
$fromArray.Add(6)
$fromArray

#you can add pipeline input into a list
$pipeList = [List[string]]::new()
Get-ChildItem $PSScriptRoot -Filter *.ps1 | ForEach-Object {$pipeList.Add($_.Name)}
$pipeList

<# TLDR
Need Fixed size? Array
Need resizable typed? List<T>
Key-Value pairs? Dictionary<Tkey,Tvalue>
No duplicates HashSet<T>
Fair ordering Queue<t>
Reverse ordering Stack<T>
Multiple threads? System.Collections.Concurrent.*
Legacy code from 2001 Hashtable /ArrayList
#>

<#Hash set
Key characteristics and usage include:

Creation: Instantiate a typed HashSet using [System.Collections.Generic.HashSet[Type]]::new(), 
such as [System.Collections.Generic.HashSet[string]]::new() for strings. 
Uniqueness: The collection automatically rejects duplicates; 
    the .Add() method returns $true if the item was new and $false if it already existed. 
Performance: It is much faster than using -Unique with Select-Object or Sort-Object for large datasets,
 making it ideal for de-duplicating lists or validating unique elements. 
Set Operations: It supports efficient in-place set theory methods like .UnionWith(), .IntersectWith(), 
and .ExceptWith() to combine, compare, or remove elements between sets. 
Limitations: HashSets are case-sensitive by default (e.g., "Apple" and "apple" are distinct) 
and do not support index-based access; elements must be iterated or converted to an array for ordered access. 
#>

function d4c {
   $searchItem = $lookupData[-1]

   $null = $lookupData -contains $searchItem
   
   $hashSetForContains = [HashSet[string]]::new([string[]]$lookupData)
   $null = $hashSetForContains.Contains($searchItem)
    
}
#>

#endregion

#region dot net runspaces

    # 10.5 .Net Runspaces
    #Requires -version 7

    #Find-Command Invoke-Parallel

    #Install-Module WFTools
    Measure-Command -Expression {
        1..50 | Invoke-Parallel -Throttle 32 -ScriptBlock {
            If(Test-Connection "192.168.20.$_" -Count 1 -Quiet){
                Write-Host "192.168.20.$_`n" -ForegroundColor Green -NoNewline
            }Else{
                Write-Host "192.168.20.$_`n" -ForegroundColor Red -NoNewline
            }
        }
    }

#endregion

#region dot net file.copy

$source = "C:\temp\burn.txt"
$destination = "D:\Curtin\ZZ\burn.txt"
[System.IO.File]::Copy($source, $destination, $true)


#endregion


$accessInfos = New-Object System.Security.AccessControl.DirectorySecurity("D:\Curtin\ITS", 6)
foreach($access in $accessInfos.Access){
    if($access.identityReference -like "Company\*" -and $access.IsInherited -eq $false){
        $access
    }
    
}


$path = "D:\Curtin\ITS"
Get-NTFSAccess -Path $path  -ExcludeInherited | ConvertTo-Json -OutVariable a