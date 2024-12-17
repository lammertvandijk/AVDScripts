#parameter passthrough
param (
    [Parameter(Mandatory=$True)][string]$KeyVaultName # The Vault name to check the availability
)

function validateKeyVaultName {
    param (
        [Parameter(Mandatory=$True)][string]$KeyVaultName # The Vault name to check the availability
    )

    # Validating KeyVault name requirements
    if ($KeyVaultName.Length -lt 3) {
        Write-Host "Azure KeyVault names should be at least 3 characters long"
        return $false
    } elseif ($KeyVaultName.Length -gt 24) {
        Write-Host "Azure KeyVault names can't be longer than 24 characters"
        return $false
    }

    if ($KeyVaultName -match "--") {
        Write-Host "Azure KeyVault names can't contain consecutive hyphens"
        return $false
    }

    if (-not ($KeyVaultName -match "^[A-Z]")) {
        Write-Host "Azure KeyVault names must start with a letter"
        return $false
    }

    if (-not ($KeyVaultName -match "\w$")) {
        Write-Host "Azure KeyVault names must end with a letter or digit"
        return $false
    }

    return $true
}

function validateKeyVaultAvailability {
    param (
        [Parameter(Mandatory=$True)][string]$KeyVaultName # The Vault name to check the availability
    )

    # Validate KeyVaultName
    $isNameValid = validateKeyVaultName -KeyVaultName $KeyVaultName
    if (-not $isNameValid) {
        return $false
    }

    # Getting the token of your current session
    $token = (Get-AzAccessToken).Token

    # Authorization header build (hash table)
    $headers = @{
        Authorization = "Bearer $token"
    }

    # Request body build (hash table)
    $body = @{
        "name" = "$KeyVaultName"
        "type" = "Microsoft.KeyVault/vaults"
    }

    # Getting the SubscriptionId of the subscription currently in use
    $subscriptionId = (Get-AzContext).Subscription.Id

    # Build the URI
    $uri = "https://management.azure.com/subscriptions/$subscriptionId/providers/Microsoft.KeyVault/checkNameAvailability?api-version=2022-07-01"

    # Making the call to the KeyVault checkNameAvailability API
    $response = Invoke-WebRequest -Method Post -Uri $uri -Headers $headers -Body $body -ErrorAction Stop

    # Response handling
    if ($response.Content -match "true") {
        return $true
    } else {
        return $false
    }
}

# Validate KeyVault availability
$isAvailable = validateKeyVaultAvailability -KeyVaultName $KeyVaultName

# Prepare output
$DeploymentScriptOutputs = @{
    KeyVaultAvailability = $isAvailable
}

# Output the result
Write-Output ($DeploymentScriptOutputs | ConvertTo-Json -Depth 10)
