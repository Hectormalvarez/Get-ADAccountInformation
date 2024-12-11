# Import the private functions
. "$PSScriptRoot\Private\UserRetrieval.ps1"
. "$PSScriptRoot\Private\PasswordInfo.ps1"
. "$PSScriptRoot\Private\LockoutInfo.ps1"
. "$PSScriptRoot\Private\AccountExpirationInfo.ps1"

function Get-ADAccountInformation {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory = $true)]
        [string] $TMID
    )

    try {
        $user = Get-ADUserByIdentifier -Identifier $TMID
        
        if (-not $user) {
            throw "User not found"
        }

        $userInfo = [ordered]@{
            Name    = $user.Name
            Enabled = $user.Enabled
        }

        $userInfo += Get-PasswordInfo -User $user
        $userInfo += Get-LockoutInfo -User $user
        $userInfo += Get-AccountExpirationInfo -User $user

        return [PSCustomObject]$userInfo
    }
    catch {
        Write-Error "Error retrieving user information: $_"
    }
}

Export-ModuleMember -Function Get-ADAccountInformation