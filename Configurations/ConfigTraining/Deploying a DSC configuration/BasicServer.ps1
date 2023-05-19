Configuration BasicServer {

    #Import-DSCResource can only be used in a Configuration
    Import-DscResource -ModuleName PSDesiredStateConfiguration -ModuleVersion 1.1
    Import-DscResource -ModuleName ComputerManagementDSC 
    Import-DscResource -ModuleName NetworkingDSC 

    Node MS {
        File Demo {
            DestinationPath = "C:\DSCDemo"
            Ensure          = "Present"
            Type            = "Directory"
        }

        File Readme {
            DestinationPath = "C:\DSCDemo\readme.txt"
            Ensure          = "Present"
            Type            = "File"
            Contents        = "Created for DSC demonstrations"
            Force           = $True
            DependsOn       = "[File]Demo"
        }

        WindowsFeature NoPS2 {
            Ensure = "Absent"
            Name   = "PowerShell-V2"
        }
        
        SMBShare Demo {
            Name        = "DemoFiles"
            Description = "Company demo share"
            ensure      = "Present"
            Path        = "C:\DSCDemo"
            FullAccess  = "company\domain admins"
            DependsOn   = "[File]Demo"
        }

        HostsFile Hosts {
            Hostname  = "SRV3.mycompany.pri"
            IPAddress = "192.168.3.60"
            Ensure    = "Present"
        }

        LocalConfigurationManager {
            RebootNodeIfNeeded = $True
            ConfigurationMode  = "ApplyAndAutoCorrect"
            ActionAfterReboot  = "ContinueConfiguration"
            RefreshMode        = "Push"
        }
    } #SRV1

} #end BasicServer configuration


basicServer -OutputPath C:\dsc