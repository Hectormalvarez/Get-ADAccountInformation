function Test-Configuration {
    [CmdletBinding()]
    param(
        [Parameter()]
        [string]$ConfigPath = "$PSScriptRoot/../Config.psd1"
    )

    try {
        # Attempt to load configuration
        $config = Import-PowerShellDataFile -Path $ConfigPath

        # Validate required sections
        $requiredSections = @('ADProperties', 'IdentifierPatterns', 'SearchProperties')
        foreach ($section in $requiredSections) {
            if (-not $config.ContainsKey($section)) {
                throw "Missing required configuration section: $section"
            }
        }

        # Validate pattern mappings
        foreach ($pattern in $config.IdentifierPatterns.Keys) {
            if (-not $config.SearchProperties.ContainsKey($pattern)) {
                throw "Missing search property mapping for pattern: $pattern"
            }
        }

        # Validate default search property
        if (-not $config.SearchProperties.ContainsKey('Default')) {
            throw "Missing default search property in SearchProperties"
        }

        # Validate ADProperties is not empty
        if ($config.ADProperties.Count -eq 0) {
            throw "ADProperties section cannot be empty"
        }

        return $true
    }
    catch {
        Write-Error "Configuration validation failed: $_"
        return $false
    }
}
