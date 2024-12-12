BeforeAll {
    # Import the UserRetrieval script that contains the function being tested
    . $PSScriptRoot/../Private/UserRetrieval.ps1
}

Describe 'Get-ADUserByIdentifier' {
    BeforeAll {
        # Define test properties that will be used to validate AD user objects
        $testProperties = @('Name', 'Enabled', 'PasswordExpired', 'LockedOut', 'PasswordLastSet', 'pwdLastSet', 'lockoutTime', 'AccountExpirationDate')
        

        # Import configuration
        $script:Config = Import-PowerShellDataFile -Path $PSScriptRoot/../Config.psd1

        # Create a mock AD user object with test data
        $testUser = @{
            Name                  = 'TestUser'
            Enabled               = $true
            PasswordExpired       = $false
            LockedOut             = $false
            PasswordLastSet       = (Get-Date)
            pwdLastSet            = (Get-Date).ToFileTime()
            lockoutTime           = 0
            AccountExpirationDate = $null
            SamAccountName        = 'testadm'
            EmployeeId            = '12345'
        }
        Mock Get-ADUser { return $testUser }
    }

    Describe 'Get-ADUserByIdentifier' {
        It 'Should query by SamAccountName when identifier matches service account pattern' {
            $result = Get-ADUserByIdentifier -Identifier 'testadm'
            Should -Invoke Get-ADUser -ParameterFilter {
                $Filter -eq "$(${Config}.SearchProperties.ServiceAccount) -eq 'testadm'"
            }
        }
    
        It 'Should query by default property when identifier does not match any patterns' {
            $result = Get-ADUserByIdentifier -Identifier '12345'
            Should -Invoke Get-ADUser -ParameterFilter {
                $Filter -eq "$(${Config}.SearchProperties.Default) -eq '12345'"
            }
        }
    
        It 'Should use configured properties when querying AD' {
            $result = Get-ADUserByIdentifier -Identifier 'testadm'
            Should -Invoke Get-ADUser -ParameterFilter {
                $null -ne $Properties -and
                @(Compare-Object $Properties ${Config}.ADProperties).Length -eq 0
            }
        }
    }
}
