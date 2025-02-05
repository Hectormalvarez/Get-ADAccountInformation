function Get-PasswordInfo {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        $User
    )
    
    $info = @{
        PasswordExpired = $false
        PasswordLastSet = $null
    }

    try {
        if ($User.PasswordLastSet) {
            $info['PasswordLastSet'] = $User.PasswordLastSet

            # Get domain password policy
            $policy = Get-ADDefaultDomainPasswordPolicy -ErrorAction Stop
            $maxPwdAge = if ($policy.MaxPasswordAge) { $policy.MaxPasswordAge.Days } else { 90 }
            
            # Convert to DateTime and ensure we're working with the correct year
            $pwdLastSet = [DateTime]::FromFileTime($User.pwdLastSet)
            
            if ($User.PasswordExpired) {
                $info['PasswordExpired'] = $true
                $info['PasswordExpiredSince'] = $pwdLastSet.AddDays($maxPwdAge)
            }
            else {
                # Ensure we're using the correct date calculation
                $expiryDate = $pwdLastSet.AddDays($maxPwdAge)
                
                # Verify the year is reasonable (not too far in the future or past)
                if ($expiryDate.Year -lt 2000 -or $expiryDate.Year -gt 2100) {
                    $info['PasswordExpires'] = 'Error calculating expiration date'
                    Write-Warning "Calculated password expiration date appears invalid: $expiryDate"
                }
                else {
                    $info['PasswordExpires'] = $expiryDate
                }
            }
        }
        else {
            $info['PasswordLastSet'] = 'Never'
            $info['PasswordExpired'] = $true
        }
    }
    catch {
        Write-Warning "Error processing password info: $_"
        $info['PasswordExpires'] = 'Error calculating expiration date'
    }
    # Add this temporarily to see raw values
    Write-Host "Debug Info:"
    Write-Host "PasswordLastSet: $($User.PasswordLastSet)"
    Write-Host "pwdLastSet: $($User.pwdLastSet)"
    Write-Host "MaxPasswordAge: $maxPwdAge days"

    return $info
}
