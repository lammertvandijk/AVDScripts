param (
    [string]$outParDomainFQDN,
    [string]$parDomainUsername,
    [securestring]$parDomainPassword
)

# Convert secure string to plain text for use in PSCredential
$securePassword = $parDomainPassword | ConvertFrom-SecureString

# Create credential object
$credential = New-Object System.Management.Automation.PSCredential($parDomainUsername, (ConvertTo-SecureString $securePassword))

# Join the domain
Add-Computer -DomainName $outParDomainFQDN -Credential $credential -Restart
