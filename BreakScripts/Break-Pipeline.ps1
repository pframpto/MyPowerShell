Break;
#region Sort
Get-Service | Sort-Object –Property Name –Descending
Get-Service | Sort Name –Desc
Get-Service | Sort Status,Name

Get-Service | Sort-Object Status,Name | fw -GroupBy Status

#endregion

#region Measure

Get-ChildItem -File c:\temp | Measure -Property Length -Sum -Average -Minimum -Max
<#

Count    : 5
Average  : 2501.6
Sum      : 12508
Maximum  : 7920
Minimum  : 0
Property : Length

#>

gsv | measure -Property status

#endregion

#region Select

Get-Process | Sort-Object –Property VM | Select-Object –First 10

Get-Service | Sort-Object –Property Name | Select-Object –Last 10

Get-Process | Sort-Object –Property CPU –Descending | Select-Object –First 5 –Skip 1

Get-ADUser -Filter * -Property Department | Sort-Object -Property Department | Select-Object Department -Unique

Get-Process | Select-Object –Property Name,ID,VM,PM,CPU | Format-Table

Get-Process | Sort-Object –Property CPU –Descending | Select-Object –Property Name,CPU –First 10

#endregion

#region Select with calculated properties

Get-Process |
Select-Object Name,ID,@{n='VirtualMemory';e={$PSItem.VM}},@{n='PagedMemory';e={$PSItem.PM}}

@{
 n='VirtualMemory';
 e={ $PSItem.VM }
 }

Get-Process |
    Select-Object Name,
        ID,
        @{n='VirtualMemory(MB)';e={$PSItem.VM / 1MB}},
        @{n='PagedMemory(MB)';e={$PSItem.PM / 1MB}}


Get-Process |
Select-Object Name,
              ID,
              @{n='VirtualMemory(MB)';e={'{0:N2}' –f ($PSItem.VM / 1MB) -as [Double] }},
              @{n='PagedMemory(MB)';e={'{0:N2}' –f ($PSItem.PM / 1MB) -as [Double] }}

#endregion


#region comparison operators

<#
Operator	Description
-eq	Equal to
-ne	Not equal to
-gt	Greater than
-lt	Less than
-le	Less than or equal to
-ge	Greater than or equal to
#>

100 -gt 10
#True
'hello' -eq 'HELLO'
#True
'hello' -ceq 'HELLO'
#False

#basic syntax
Get-Service | Where Status –eq Running
#Advanced syntax
Get-Service | Where Status –eq Running
#can be written as
Get-Service | Where-Object –FilterScript { $PSItem.Status –eq 'Running' }

Get-Service | Where {$PSItem.Status –eq 'Running'}
Get-Service | ? {$_.Status –eq 'Running'}

#combining multiple criteria
Get-EventLog –LogName Security –Newest 100 |
Where { $PSItem.EventID –eq 4672 –and $PSItem.EntryType –eq 'SuccessAudit' }

Get-Process | Where { $PSItem.CPU –gt 30 –and $_.VM –lt 10000 }

#both of there are true
Get-Process | Where { $PSItem.Responding –eq $True }

Get-Process | Where { $PSItem.Responding }

Get-Process | Where { -not $PSItem.Responding } # gets items not responding

Get-Service | Where {$PSItem.Name.Length –gt 8}

Get-ChildItem | Where { -not $PSItem.PSIsContainer }
#is worse than
Get-ChildItem -File
#because you should always filter left and format right.

#endregion

#region Enumerate objects in the pipeline

Get-Process –Name Notepad | Stop-Process

Stop-Process –Name Notepad

Get-ChildItem –Path C:\Encrypted\  -File | ForEach-Object  -MemberName Encrypt

Get-ChildItem –Path C:\Encrypted\ -File | ForEach Encrypt

Get-ChildItem –Path C:\Encrypted\ -File | % Encrypt

Get-ChildItem C:\temp -File -Filter w* | % delete # performs the delete method on each item

#advanced syntax
Get-ChildItem –Path C:\ToEncrypt\ -File | ForEach-Object –Process { $PSItem.Encrypt() }

1..100 | ForEach-Object { Get-Random }

#endregion

#region Send and pass data as output from the pipeline

Get-Service |
Sort-Object –Property Status, Name |
Select-Object –Property DisplayName,Status |
Out-File –FilePath ServiceList.csv

Get-Service | ConvertTo-Csv | Out-File Services.csv
Get-Service | Export-Csv Services.csv

#endregion

#region pass pipline objects

Get-ADUser -Filter {Name -eq 'Perry Brill'} | Set-ADUser -City Seattle

#Pass data by using ByValue
'BITS','WinRM' | Get-Service

"BITS","WinRM" | Get-Member
<# 
   TypeName: System.String

Name             MemberType            Definition
----             ----------            ----------
#>

#Pass data by using ByPropertyName
Get-LocalUser | Stop-Process
Get-LocalUser | Get-Member
Get-Help Stop-Process -ShowWindow 
#Renaming properties
Get-ADComputer -Filter * | Get-Process

Get-ADComputer -Filter * | Select-Object @{n='ComputerName';e={$PSItem.Name}} | Get-Process

#ByPropertyName parameters
man Stop-Process
<#
-ID <Int32[]>

Required?                    true
    Position?                    0
    Default value                None
    Accept pipeline input?       True (ByPropertyName)
    Accept wildcard characters?  False

-InputObject <Process[]>

Required?                    true
    Position?                    0
    Default value                None
    Accept pipeline input?       True (ByValue)
    Accept wildcard characters?  false

-Name <String[]>

Required?                    true
    Position?                    named
    Default value                None
    Accept pipeline input?       True (ByPropertyName)
    Accept wildcard characters?  false
#>

#Use manual parameters to override the pipeline
Get-Process -Name Notepad | Stop-Process –Name Notepad #this produces this error:
<#Stop-Process : The input object cannot be bound to any parameters for the command either because the command does not take pipeline input or the input 
and its properties do not match any of the parameters that take pipeline input.
#>

#Use parenthetical commands
Get-ADGroup "London Users" | Add-ADGroupMember -Members (Get-ADUser -Filter {City -eq 'London'})

#Expand property values
Get-ADComputer –Filter *
# cant use this because it is the wrong type
Get-Process –ComputerName (Get-ADComputer –Filter *)
#this does not work either
Get-Process –ComputerName (Get-ADComputer –Filter * | Select-Object –Property Name)
#this works
Get-Process –ComputerName (Get-ADComputer –Filter * | Select-Object –ExpandProperty Name)

#this fails also because it produces the wrong output as a object
Get-ADUser Ty -Properties MemberOf | Get-ADGroup
Get-ADUser Ty -Properties MemberOf | Select-Object -ExpandProperty MemberOf | Get-ADGroup

#endregion









