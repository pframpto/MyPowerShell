<#
 .SYNOPSIS
    Creates Snapshot onb ESX server
.DESCRIPTION
    Creates Snapshot onb ESX server
    Relies on the PowerCLI snapin being installed.
.EXAMPLE
    new-mySnapshot -vmname VM1 -SnaphotName "Winter Snapshot"
#>
function new-mySnapshot {
    [cmdletbinding()]
    param (
        $vmname,
        $SnaphotName
        )
    New-Snapshot -VM $vmname -Name $snaphotname
}
$root = Get-Credential -Message "Enter credentials for the ESX or virtual center server"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer Example-ESX1 -credential $root
new-mySnapshot -vmname VM1 -SnaphotName "Winter Snapshot"