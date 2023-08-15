function Get-HighMemoryProcesses {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [int64]$MemoryThresholdKB
    )
    Get-Process | Where-Object { ($_.WorkingSet64 / 1kb) -gt $MemoryThresholdKB}
}

Get-HighMemoryProcesses -MemoryThresholdKB 100000