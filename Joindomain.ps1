param (
    [string]$outParDomainFQDN,
    [string]$parDomainUsername,
    [string]$parDomainPassword
)

# Convert plain text password to secure string
$securePassword = ConvertTo-SecureString -String $parDomainPassword -AsPlainText -Force

# Create the credential object
$credential = New-Object System.Management.Automation.PSCredential($parDomainUsername, $securePassword)

# Join the domain
Add-Computer -DomainName $outParDomainFQDN -Credential $credential -Restart
