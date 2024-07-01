param (
    [string]$domainServicesName,
    [string]$domainUsername,
    [string]$domainPassword
)

$securePassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($domainUsername, $securePassword)

Add-Computer -DomainName $domainServicesName -Credential $credential -Restart
