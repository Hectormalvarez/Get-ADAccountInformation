@{
    # AD Properties to query
    ADProperties = @(
        'Name',
        'Enabled',
        'PasswordExpired',
        'LockedOut',
        'PasswordLastSet',
        'pwdLastSet',
        'lockoutTime',
        'AccountExpirationDate'
    )

    # Search identifiers configuration
    IdentifierPatterns = @{
        ServiceAccount = 'adm'
        CloudAccount   = 'aad'
    }

    # Search property mappings
    SearchProperties = @{
        Default      = 'EmployeeID'
        ServiceAccount = 'SamAccountName'
        CloudAccount   = 'SamAccountName'
    }
}
