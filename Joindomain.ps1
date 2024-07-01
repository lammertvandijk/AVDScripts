param (
    [string]$domainServicesName,
    [string]$ouPath,
    [string]$domainUsername,
    [string]$domainPassword
)

$securePassword = ConvertTo-SecureString $domainPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ($domainUsername, $securePassword)

Add-Computer -DomainName $domainServicesName -OUPath $ouPath -Credential $credential -Restart
