param (
    [string]$outParDomainFQDN,
    [string]$parDomainUsername,
    [string]$parDomainPassword
)

# Create the credential object
$credential = New-Object System.Management.Automation.PSCredential($parDomainUsername, $parDomainPassword)

# Join the domain
Add-Computer -DomainName $outParDomainFQDN -Credential $credential -Restart
