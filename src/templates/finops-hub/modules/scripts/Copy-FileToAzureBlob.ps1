$json = [ordered]@{
    '$schema'    = 'https://aka.ms/finops/hubs/settings-schema'
    type         = 'HubInstance'
    version      = '0.0.1'
    learnMore    = 'https://aka.ms/finops/hubs'
    exportScopes = @()
    retention    = @{
        'msexports' = @{
            days = 0
        }
        'ingestion'     = @{
            months = 13
        }
    }
}

# Set values from inputs
$json.exportScopes = $env:exportScopes.Split('|')
$json.retention['msexports'].days = [Int32]::Parse($env:exportRetentionInDays)
$json.retention.ingestion.months = [Int32]::Parse($env:ingestionRetentionInMonths)

# Save file to storage
$settingsFile = Join-Path -Path .\ -ChildPath 'settings.json'
$json | ConvertTo-Json | Out-File $settingsFile
$ctx = New-AzStorageContext -StorageAccountName $env:storageAccountName -StorageAccountKey $env:storageAccountKey
Set-AzStorageBlobContent -Container config -Context $ctx -File $settingsFile
