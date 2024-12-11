function Get-AccountExpirationInfo {
    param($user)
    $info = @{}
    if ($user.AccountExpired) {
        $info = @{
            AccountExpirationDate    = (Get-Date $user.AccountExpirationDate).ToLocalTime()
            AccountExpirationDateUTC = Get-Date $user.AccountExpirationDate
        }
    }
    return $info
}