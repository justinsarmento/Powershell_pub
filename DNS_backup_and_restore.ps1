# Function to perform DNS backup
function Backup-Dns {
    # Set the DNS server name
    $dnsServer = "YourDnsServerName"

    # Set the backup path
    $backupPath = "C:\Path\To\Backup"

    # Create a timestamp for the backup file
    $timestamp = Get-Date -Format "yyyyMMddHHmmss"
    $backupFileName = "DNSBackup_$timestamp"

    # Combine the backup path and file name
    $backupFullPath = Join-Path -Path $backupPath -ChildPath "$backupFileName"

    # Export each DNS zone
    Get-DnsServerZone -ComputerName $dnsServer | ForEach-Object {
        $zoneName = $_.ZoneName
        $zoneBackupPath = Join-Path -Path $backupFullPath -ChildPath "$zoneName.dnsbackup"

        Export-DnsServerZone -Name $zoneName -FileName $zoneBackupPath -Force
    }

    Write-Host "DNS backup completed successfully. Backup files saved to: $backupFullPath"
}

# Function to perform DNS restore
function Restore-Dns {
    # Set the DNS server name
    $dnsServer = "YourDnsServerName"

    # Set the path to the backup files
    $backupPath = "C:\Path\To\Backup"

    # Get the list of backup files in the backup path
    $backupFiles = Get-ChildItem -Path $backupPath -Filter "*.dnsbackup"

    # Restore each DNS zone
    foreach ($backupFile in $backupFiles) {
        $zoneName = $backupFile.BaseName
        $zoneBackupPath = $backupFile.FullName

        Import-DnsServerZone -FileName $zoneBackupPath -ZoneName $zoneName -Force -Overwrite
    }

    Write-Host "DNS restore completed successfully."
}

# Prompt the user to choose between backup and restore
$choice = Read-Host "Choose operation: (1) Backup or (2) Restore"

# Perform the chosen operation
switch ($choice) {
    '1' { Backup-Dns }
    '2' { Restore-Dns }
    default { Write-Host "Invalid choice. Exiting script." }
}