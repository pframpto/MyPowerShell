Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Install-WindowsFeature RSAT-AD-Tools -IncludeAllSubFeature
"2" | out-file ./1.txt