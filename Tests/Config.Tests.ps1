# Tests/Config.Tests.ps1

Describe 'Configuration Validation' {
    BeforeAll {
        # Import the configuration
        $script:ConfigPath = "$PSScriptRoot/../Config.psd1"
        $script:Config = Import-PowerShellDataFile -Path $ConfigPath
    }

    Context 'Configuration File' {
        It 'Should exist' {
            Test-Path $ConfigPath | Should -Be $true
        }

        It 'Should be valid PowerShell data file' {
            { Import-PowerShellDataFile -Path $ConfigPath } | Should -Not -Throw
        }
    }

    Context 'Required Sections' {
        It 'Should contain ADProperties section' {
            $Config.ContainsKey('ADProperties') | Should -Be $true
            $Config.ADProperties | Should -Not -BeNullOrEmpty
        }

        It 'Should contain IdentifierPatterns section' {
            $Config.ContainsKey('IdentifierPatterns') | Should -Be $true
            $Config.IdentifierPatterns | Should -Not -BeNullOrEmpty
        }

        It 'Should contain SearchProperties section' {
            $Config.ContainsKey('SearchProperties') | Should -Be $true
            $Config.SearchProperties | Should -Not -BeNullOrEmpty
        }
    }

    Context 'Pattern Mappings' {
        It 'Should have SearchProperties for each IdentifierPattern' {
            foreach ($pattern in $Config.IdentifierPatterns.Keys) {
                $Config.SearchProperties.ContainsKey($pattern) | Should -Be $true
            }
        }
    }

    Context 'Default Search Property' {
        It 'Should have a Default search property defined' {
            $Config.SearchProperties.ContainsKey('Default') | Should -Be $true
            $Config.SearchProperties.Default | Should -Not -BeNullOrEmpty
        }
    }
}
