param (
    [string]$domainServicesName,
    [string]$domainUsername,
    [string]$domainPassword
)

$securePassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($domainUsername, $securePassword)

Write-Output "Credentials created" | Out-File -FilePath C:\domainjoin.log -Append

try {
    Write-Output "Joining domain $domainName" | Out-File -FilePath C:\domainjoin.log -Append
    Add-Computer -DomainName $domainName -Credential $credential -Restart
} catch {
    Write-Error "Error joining domain: $_" | Out-File -FilePath C:\domainjoin.log -Append
}

Add-Computer -DomainName $domainServicesName -Credential $credential -Restart
