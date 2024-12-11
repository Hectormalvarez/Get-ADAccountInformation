function Get-ADUserByIdentifier {
    param (
        [string] $Identifier
    )
    
    $properties = @('Name', 'Enabled', 'PasswordExpired', 'LockedOut', 'PasswordLastSet', 'pwdLastSet', 'lockoutTime', 'AccountExpirationDate')
    
    if ($Identifier -match 'adm|aad') { 
        return Get-ADUser -Filter "SamAccountName -eq '$Identifier'" -Properties $properties
    }
    else { 
        return Get-ADUser -Filter "employeeid -eq '$Identifier'" -Properties $properties
    }
}