function Get-ADUserByIdentifier {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$Identifier
    )

    # Import configuration if not already loaded
    if (-not $script:Config) {
        $script:Config = Import-PowerShellDataFile -Path "$PSScriptRoot/../Config.psd1"
    }

    # Determine which property to search by
    $searchProperty = $Config.SearchProperties.Default
    foreach ($pattern in $Config.IdentifierPatterns.GetEnumerator()) {
        if ($Identifier -match $pattern.Value) {
            $searchProperty = $Config.SearchProperties[$pattern.Key]
            break
        }
    }

    # Build and execute query
    $filter = "$searchProperty -eq '$Identifier'"
    Get-ADUser -Filter $filter -Properties $Config.ADProperties
}
