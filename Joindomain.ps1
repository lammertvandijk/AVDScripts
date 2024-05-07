param (
    [string]$outParDomainFQDN,
    [string]$parDomainUsername,
    [securestring]$parDomainPassword
)

# Define domain credentials
$securePassword = ConvertTo-SecureString $parDomainPassword -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential($parDomainUsername, $securePassword)

# Join the domain
Add-Computer -DomainName $DomainName -Credential $credential -Restart