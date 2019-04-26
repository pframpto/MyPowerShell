function Set-PDTFullAccessandSendAs {
    [cmdletbinding()]
    param(
        $delegate,
        $identity
    )
    Add-MailboxPermission -Identity $identity -AccessRights "FullAccess" -User $delegate
    Add-OPMailboxPermission -Identity $identity -AccessRights "FullAccess" -User $delegate
    Add-OPADPermission -Identity $identiy -User $delegate -AccessRights ExtendedRight -ExtendedRights "send as"
    Add-RecipientPermission -Identity $identity -AccessRights Sendas -Trustee $delegate -confirm:$false

}

Set-PDTFullAccessandSendAs -identity "ABC@company.com" -delegate "lyn.sim@company.com"