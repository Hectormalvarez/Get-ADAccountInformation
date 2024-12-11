<#
.SYNOPSIS
Retrieves detailed Active Directory account information for a specified user.

.DESCRIPTION
This function provides the following information about an AD user:
* Enabled status
* Lockout status
* Lockout time (if locked out, both local and UTC)
* Whether the lockout occurred after the last password change (if locked out)
* Password status (expired, expiration date, or time since expiration)
* Password last set date and time
* Account expiration status (if applicable)
* Account expiration date and time (if applicable, both local and UTC)

The function can find users by their TMID (employee ID).

.PARAMETER TMID
The user's TMID (employee ID).

.EXAMPLE
Get-ADAccountInformation -TMID adm.t1.2340508

.EXAMPLE
Get-ADAccountInformation -TMID 123456

.EXAMPLE
# Scenario 1: Active account, password not expired
Get-ADAccountInformation -TMID 123456 | Format-List

Name               : Jane Smith 
Enabled            : True
AccountExpired     : False
LockedOut          : False 
PasswordExpired    : False
PasswordExpires    : 6/3/2024 4:50:00 PM 

.EXAMPLE
# Scenario 2: Account locked out, password expired
Get-ADAccountInformation -TMID 123456 | Format-List

Name               : Jane Smith 
Enabled            : True
AccountExpired     : False
PasswordLastSet    : 1/2/2024 5:04:35 PM
LockedOut          : True
LockoutTime        : 4/3/2024 9:21:15 AM 
LockoutTimeUTC     : 4/3/2024 2:21:15 PM
LockedAfterPasswordSet : False
PasswordExpired    : True
PasswordExpiredSince   : 4/2/2024 5:04:35 PM

.EXAMPLE
# Scenario 3: Expired account
Get-ADAccountInformation -TMID 123456 | Format-List

Name                     : Jane Smith 
Enabled                  : True 
AccountExpired           : True
AccountExpirationDate    : 3/28/2024 9:31:00 AM
AccountExpirationDateUTC : 3/28/2024 2:31:00 PM 
PasswordExpired          : False 
LockedOut                : False 

.EXAMPLE
# Scenario 4: Active account, locked out, password not expired
Get-ADAccountInformation -TMID 123456 | Format-List

Name               : Jane Smith 
Enabled            : True
AccountExpired     : False
PasswordExpired    : False 
LockedOut          : True
PasswordLastSet    : 3/22/2024 2:45:39 PM
LockoutTime        : 4/3/2024 10:55:01 AM
LockoutTimeUTC     : 4/3/2024 3:55:01 PM
LockedAfterPasswordSet : True
#>
function Get-ADAccountInformation {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $TMID
    )

    if ($TMID -match 'adm|aad') { 
        $user = Get-ADUser -Filter "SamAccountName -eq '$TMID'" -Properties '*'
    }
    else { 
        $user = Get-ADUser -Filter "employeeid -eq '$TMID'" -Properties '*'
    }

    $userInfo = [ordered]@{
        Name            = $user.Name
        Enabled         = $user.Enabled
        PasswordExpired = $user.PasswordExpired
        LockedOut       = $user.LockedOut
        PasswordLastSet = $user.PasswordLastSet
    }

    if ($user.PasswordExpired) {
        $userInfo += @{
            PasswordExpiredSince = (Get-Date $user.pwdLastSet).ToLocalTime().AddDays(90) 
        }
    }
    elseif ($user.pwdLastSet) {
        $userInfo += @{
            PasswordExpires = (Get-Date $user.pwdLastSet).ToLocalTime().AddDays(90)
        }
    }
    if ($user.LockedOut) { 
        $userInfo += @{
            LockoutTime            = (Get-Date $user.lockoutTime).ToLocalTime()
            LockoutTimeUTC         = Get-Date $user.lockoutTime 
            PasswordLastSet        = Get-Date $user.PasswordLastSet
            LockedAfterPasswordSet = ((Get-Date $user.lockoutTime) -le $user.PasswordLastSet) 
        }
    } 
    if ($user.AccountExpired) {
        $userInfo += @{
            AccountExpirationDate    = (Get-Date $user.AccountExpirationDate).ToLocalTime()
            AccountExpirationDateUTC = Get-Date $user.AccountExpirationDate
        }
    }

    $Output = [PSCustomObject]$userInfo 
    return $Output
}

Export-ModuleMember -Function Get-ADAccountInformation
