# Promote the server to a domain controller
Install-WindowsFeature -Name AD-Domain-Services -IncludeManagementTools

# Configure AD DS (you may need to customize these parameters)
Install-ADDSForest -DomainName "YourDomainName" -DomainNetbiosName "YourNetbiosName" -InstallDns -Force -NoRebootOnCompletion

# Optional: Specify the Directory Services Restore Mode administrator password
$dsrmPassword = ConvertTo-SecureString -AsPlainText -Force "YourDSRMPassword"
Set-LocalAdministratorPassword -Password $dsrmPassword

# Install DNS
Install-WindowsFeature -Name DNS -IncludeManagementTools

# Restart the server after installation
Restart-Computer -Force
