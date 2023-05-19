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
        
        

        HostsFile Hosts {
            Hostname  = "SRV3.mycompany.pri"
            IPAddress = "192.168.3.60"
            Ensure    = "Present"
        }

        
    } #SRV1


    smbshare demo {
        name = "Demo"
        path = "C:\DSCDemo\"

    }

} #end BasicServer configuration


basicServer -OutputPath C:\dsc