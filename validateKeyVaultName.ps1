#source: https://medium.com/@TimGroothuis/validating-azure-keyvault-names-with-powershell-3d672a40efa1
#The account with which you generate the token needs to have enough permissions (KeyVault Contributor should suffice).
#the code uses the current connected subscriptionId

#paramter passtrough
param (
    [Parameter(Mandatory=$True)][string]$KeyVaultName # The Vault name to check the availability
)

function validateKeyVaultName {
    param (
        [Parameter(Mandatory=$True)][string]$KeyVaultName # The Vault name to check the availability
    )

    # Validating KeyVault name length requirements
if($KeyVaultName.Length -lt 3){
    Write-Host "Azure KeyVault names should be at least 3 charcters long"
    break
} elseif($KeyVaultName.Length -gt 24){
    Write-Host "Azure KeyVault names can't be longer than 24 charcters"
    break
}

# Validating KeyVault hyphen requirements
if($KeyVaultName -match "--"){
    Write-Host "Azure KeyVault names can't contain consecutive hyphens"
    break
}

# Validating Keyvault starting character requirements
if(-not($KeyVaultName -match "^[A-Z]")){
    Write-Host "Azure KeyVault names must start with a letter"
    break
}

# Validating Keyvault ending character requirements
if(-not($KeyVaultName -match "\w$")){
    Write-Host "Azure KeyVault names must end with a letter or digit"
    break
}
}

function validateKeyVaultAvailability {
    param (
        [Parameter(Mandatory=$True)][string]$KeyVaultName # The Vault name to check the availability
    )
    # Validate KeyVaultName
    validateKeyVaultName -KeyVaultName $KeyVaultName
    

    # Getting the token of your current session
    $token = (Get-AzAccessToken).Token


    #authorization header build (hash table)
    $headers = @{
         Authorization = "Bearer $token"
    }

    #request body build (hash table)
    $body = @{
        "name" = "$KeyVaultName";
        "type" = "Microsoft.KeyVault/vaults"
    }

    #Getting the SubscriptionId of the subscription currently in use
    $subscriptionId = (Get-AzContext).Subscription.Id 

    # build the uri 
    $uri = "https://management.azure.com/subscriptions/$subscriptionId/providers/Microsoft.KeyVault/checkNameAvailability?api-version=2022-07-01"

    # Making the call to the Keyvault checkNameAvailability API and cathing the response in a variable
    $response = Invoke-WebRequest -Method Post -Uri $uri -Headers $headers -Body $body -ErrorAction Stop


    #response
    if($response.Content -match "true"){
        Write-Host "KeyVault Name available"
        return $True
    } else {
         Write-Host "KeyVault Name unavailable"
         return $False
} 
}

validateKeyVaultAvailability -KeyVaultName $KeyVaultName







