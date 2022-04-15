Class MyRUser{
    [string]$DisplayName 
    [string]$MobilePhone 
    [array]$MemberShip # groups users is a member of.

    MyRUser($name){
        $this.DisplayName = (get-aduser $name -Properties displayname).displayname
        $this.MobilePhone = (Get-ADUser $name -Properties mobilephone).mobilephone
        $this.MemberShip = (Get-aduser $name -Properties memberof).memberof
    }

}

$gusr = [MyRuser]::new("Adam.Smith31")
($gusr.MemberShip)