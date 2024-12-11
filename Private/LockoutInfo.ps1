function Get-LockoutInfo {
    param($user)
    $info = @{}
    if ($user.LockedOut) { 
        $info = @{
            LockoutTime            = (Get-Date $user.lockoutTime).ToLocalTime()
            LockoutTimeUTC         = Get-Date $user.lockoutTime 
            LockedAfterPasswordSet = ((Get-Date $user.lockoutTime) -le $user.PasswordLastSet) 
        }
    } 
    return $info
}