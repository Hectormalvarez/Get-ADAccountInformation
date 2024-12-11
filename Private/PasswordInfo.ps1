function Get-PasswordInfo {
    param($user)
    $info = @{
        PasswordExpired = $user.PasswordExpired
        PasswordLastSet = $user.PasswordLastSet
    }
    if ($user.PasswordExpired) {
        $info['PasswordExpiredSince'] = (Get-Date $user.pwdLastSet).ToLocalTime().AddDays(90)
    }
    elseif ($user.pwdLastSet) {
        $info['PasswordExpires'] = (Get-Date $user.pwdLastSet).ToLocalTime().AddDays(90)
    }
    return $info
}