# Get-ADAccountInformation

A PowerShell module for retrieving detailed Active Directory account information. This tool assists helpdesk staff by providing comprehensive account status including enabled state, password information, lockout status, and expiration details.

## Prerequisites

- PowerShell 5.1+
- Active Directory PowerShell Module
- AD Read Permissions

## Installation

1. Copy the module folder to one of these locations:
   ```powershell
   # Current user
   $HOME\Documents\WindowsPowerShell\Modules\Get-ADAccountInformation

   # All users
   $env:ProgramFiles\WindowsPowerShell\Modules\Get-ADAccountInformation
   ```

2. Import the module:
   ```powershell
   Import-Module Get-ADAccountInformation
   ```

## Usage

### Basic Commands

```powershell
# Query by employee ID
Get-ADAccountInformation -TMID "123456"

# Query admin account
Get-ADAccountInformation -TMID "admsmith"
```

### Sample Output

```
Name                    : John Smith
Enabled                 : True
PasswordExpired         : False
PasswordLastSet         : 1/15/2024 9:00:00 AM
PasswordExpires         : 4/14/2024 9:00:00 AM
ApplicablePasswordPolicy: Default Domain Policy
LockoutTime            : Never
AccountExpirationDate  : Never
```

### Properties Returned

- **Account Status**
  - Name
  - Enabled

- **Password Details**
  - PasswordExpired
  - PasswordLastSet
  - PasswordExpires/PasswordExpiredSince
  - Password Policy Information

- **Lockout Status** (if locked)
  - LockoutTime
  - LockoutTimeUTC
  - LockedAfterPasswordSet

- **Expiration Info** (if configured)
  - AccountExpirationDate
  - AccountExpirationDateUTC

## Troubleshooting

### Common Issues

1. Module Not Found
   ```powershell
   # Verify module is available
   Get-Module -ListAvailable Get-ADAccountInformation
   ```

2. AD Module Missing
   ```powershell
   # Install RSAT AD PowerShell (requires admin)
   Add-WindowsCapability -Name Rsat.ActiveDirectory.DS-LDS.Tools~~~~0.0.1.0 -Online
   ```

### Logs

Operations are logged to:
`<ModuleFolder>\Logs\ADAccountInfo_YYYYMMDD.log`

## Required Permissions

- Read access to AD user objects
- Read access to password policies

## Version

Current Version: 0.0.1
