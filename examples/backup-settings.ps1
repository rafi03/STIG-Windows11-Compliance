<#
.SYNOPSIS
    Backs up current system settings before applying STIG remediations
.DESCRIPTION
    Creates registry backups and system snapshots to allow rollback of STIG changes if needed.
    This script should be run BEFORE applying any STIG remediation scripts.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
.USAGE
    Run before applying STIG remediations to create backup
    Example syntax:
    PS C:\> .\backup-settings.ps1
#>

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Create backup directory
$BackupDir = "C:\STIGBackups"
$Timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$BackupPath = Join-Path $BackupDir "STIG_Backup_$Timestamp"

try {
    if (!(Test-Path $BackupDir)) {
        New-Item -Path $BackupDir -ItemType Directory -Force | Out-Null
        Write-Host "Created backup directory: $BackupDir" -ForegroundColor Cyan
    }
    
    New-Item -Path $BackupPath -ItemType Directory -Force | Out-Null
    Write-Host "Created backup session directory: $BackupPath" -ForegroundColor Cyan
} catch {
    Write-Host "Error creating backup directory: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Green
Write-Host "WINDOWS 11 STIG SETTINGS BACKUP" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Green
Write-Host "Backup Location: $BackupPath" -ForegroundColor Cyan
Write-Host "Date: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

# Registry paths to backup
$RegistryPaths = @(
    @{
        Name = "Event Logs Configuration"
        Path = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\EventLog"
        File = "EventLogs.reg"
    },
    @{
        Name = "Windows Policies"
        Path = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows"
        File = "WindowsPolicies.reg"
    },
    @{
        Name = "Explorer Policies"
        Path = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies"
        File = "ExplorerPolicies.reg"
    },
    @{
        Name = "LSA Security Settings"
        Path = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Lsa"
        File = "LSASettings.reg"
    },
    @{
        Name = "Internet Explorer Policies"
        Path = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Internet Explorer"
        File = "IEPolicies.reg"
    },
    @{
        Name = "PowerShell Policies"
        Path = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\PowerShell"
        File = "PowerShellPolicies.reg"
    },
    @{
        Name = "Windows Installer Policies"
        Path = "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\Installer"
        File = "InstallerPolicies.reg"
    },
    @{
        Name = "System Policies"
        Path = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        File = "SystemPolicies.reg"
    }
)

$BackupSummary = @()
$SuccessfulBackups = 0
$FailedBackups = 0

# Backup each registry path
foreach ($RegPath in $RegistryPaths) {
    Write-Host "Backing up: $($RegPath.Name)..." -ForegroundColor Yellow
    
    $BackupFile = Join-Path $BackupPath $RegPath.File
    
    try {
        # Use reg.exe to export registry
        $Result = & reg.exe export "$($RegPath.Path)" "$BackupFile" /y 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Successfully backed up to $($RegPath.File)" -ForegroundColor Green
            $FileSize = (Get-Item $BackupFile).Length
            $BackupSummary += [PSCustomObject]@{
                Component = $RegPath.Name
                Status = "Success"
                File = $RegPath.File
                SizeKB = [math]::Round($FileSize / 1KB, 2)
                Error = $null
            }
            $SuccessfulBackups++
        } else {
            throw "Registry export failed with exit code $LASTEXITCODE"
        }
    } catch {
        Write-Host "  ✗ Failed to backup $($RegPath.Name): $($_.Exception.Message)" -ForegroundColor Red
        $BackupSummary += [PSCustomObject]@{
            Component = $RegPath.Name
            Status = "Failed"
            File = $RegPath.File
            SizeKB = 0
            Error = $_.Exception.Message
        }
        $FailedBackups++
    }
}

# Backup current Group Policy settings
Write-Host ""
Write-Host "Backing up Group Policy settings..." -ForegroundColor Yellow
try {
    $GPBackupFile = Join-Path $BackupPath "GroupPolicy_Report.html"
    & gpresult.exe /h "$GPBackupFile" /f 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Group Policy report saved to GroupPolicy_Report.html" -ForegroundColor Green
        $SuccessfulBackups++
    } else {
        Write-Host "  ✗ Failed to generate Group Policy report" -ForegroundColor Red
        $FailedBackups++
    }
} catch {
    Write-Host "  ✗ Error creating Group Policy backup: $($_.Exception.Message)" -ForegroundColor Red
    $FailedBackups++
}

# Backup current audit policy
Write-Host "Backing up Audit Policy settings..." -ForegroundColor Yellow
try {
    $AuditBackupFile = Join-Path $BackupPath "AuditPolicy_Backup.csv"
    & auditpol.exe /get /category:* /r | Out-File -FilePath $AuditBackupFile -Encoding UTF8
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Audit policy saved to AuditPolicy_Backup.csv" -ForegroundColor Green
        $SuccessfulBackups++
    } else {
        Write-Host "  ✗ Failed to backup audit policy" -ForegroundColor Red
        $FailedBackups++
    }
} catch {
    Write-Host "  ✗ Error creating audit policy backup: $($_.Exception.Message)" -ForegroundColor Red
    $FailedBackups++
}

# Create system information snapshot
Write-Host "Creating system information snapshot..." -ForegroundColor Yellow
try {
    $SystemInfoFile = Join-Path $BackupPath "SystemInfo.txt"
    $SystemInfo = @"
Windows 11 STIG Backup - System Information
==========================================
Date: $(Get-Date)
Computer: $env:COMPUTERNAME
Domain: $env:USERDOMAIN
User: $env:USERNAME

System Information:
$((Get-ComputerInfo | Format-List | Out-String))

PowerShell Version:
$($PSVersionTable | Format-Table | Out-String)

Installed Windows Features:
$(Get-WindowsOptionalFeature -Online | Where-Object {$_.State -eq "Enabled"} | Select-Object FeatureName, State | Format-Table | Out-String)
"@
    
    $SystemInfo | Out-File -FilePath $SystemInfoFile -Encoding UTF8
    Write-Host "  ✓ System information saved to SystemInfo.txt" -ForegroundColor Green
    $SuccessfulBackups++
} catch {
    Write-Host "  ✗ Error creating system information snapshot: $($_.Exception.Message)" -ForegroundColor Red
    $FailedBackups++
}

# Create restore instructions
Write-Host "Creating restore instructions..." -ForegroundColor Yellow
try {
    $RestoreInstructions = @"
WINDOWS 11 STIG BACKUP RESTORE INSTRUCTIONS
===========================================

Backup Created: $(Get-Date)
Backup Location: $BackupPath

AUTOMATED RESTORE:
Run the restore-settings.ps1 script with the backup path:
PS> .\restore-settings.ps1 -BackupPath "$BackupPath"

MANUAL RESTORE (if automated restore fails):

1. REGISTRY RESTORE:
   Open Command Prompt as Administrator and run:
   
   reg import "$BackupPath\EventLogs.reg"
   reg import "$BackupPath\WindowsPolicies.reg"
   reg import "$BackupPath\ExplorerPolicies.reg"
   reg import "$BackupPath\LSASettings.reg"
   reg import "$BackupPath\IEPolicies.reg"
   reg import "$BackupPath\PowerShellPolicies.reg"
   reg import "$BackupPath\InstallerPolicies.reg"
   reg import "$BackupPath\SystemPolicies.reg"

2. GROUP POLICY REFRESH:
   gpupdate /force

3. AUDIT POLICY RESTORE:
   auditpol /restore /file:"$BackupPath\AuditPolicy_Backup.csv"

4. SYSTEM RESTART:
   Restart the computer to ensure all changes take effect.

VERIFICATION:
After restore, run: .\compliance-check.ps1 to verify settings

EMERGENCY CONTACTS:
- System Administrator: [Add contact info]
- IT Support: [Add contact info]

WARNING: 
- Only restore these settings if STIG changes cause system issues
- Test restore process in non-production environment first
- Keep this backup until STIG changes are verified stable

"@
    
    $RestoreFile = Join-Path $BackupPath "RESTORE_INSTRUCTIONS.txt"
    $RestoreInstructions | Out-File -FilePath $RestoreFile -Encoding UTF8
    Write-Host "  ✓ Restore instructions saved to RESTORE_INSTRUCTIONS.txt" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Error creating restore instructions: $($_.Exception.Message)" -ForegroundColor Red
}

# Generate backup summary
Write-Host ""
Write-Host "=" * 60 -ForegroundColor Green
Write-Host "BACKUP SUMMARY" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Green

Write-Host "Total Components: $($SuccessfulBackups + $FailedBackups)" -ForegroundColor Gray
Write-Host "Successfully Backed Up: $SuccessfulBackups" -ForegroundColor Green
Write-Host "Failed Backups: $FailedBackups" -ForegroundColor Red

if ($FailedBackups -eq 0) {
    Write-Host "✓ Complete backup successful!" -ForegroundColor Green
} else {
    Write-Host "⚠ Backup completed with $FailedBackups failures" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "BACKUP DETAILS:" -ForegroundColor Cyan
$BackupSummary | Format-Table -AutoSize

# Calculate total backup size
$TotalSize = (Get-ChildItem $BackupPath -Recurse | Measure-Object -Property Length -Sum).Sum
$TotalSizeMB = [math]::Round($TotalSize / 1MB, 2)

Write-Host "Backup Location: $BackupPath" -ForegroundColor Cyan
Write-Host "Total Backup Size: $TotalSizeMB MB" -ForegroundColor Cyan
Write-Host ""

Write-Host "NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. Verify backup files are created successfully" -ForegroundColor Gray
Write-Host "2. Store backup location safely: $BackupPath" -ForegroundColor Gray
Write-Host "3. Run STIG remediation scripts: .\Run-All-STIG-Remediations.ps1" -ForegroundColor Gray
Write-Host "4. Keep this backup until STIG changes are verified stable" -ForegroundColor Gray

if ($FailedBackups -gt 0) {
    Write-Host ""
    Write-Host "WARNING: Some backups failed. Review failed items before proceeding." -ForegroundColor Red
    Write-Host "Consider manually backing up failed components before applying STIG changes." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Backup completed at $(Get-Date)" -ForegroundColor Gray
Write-Host "=" * 60 -ForegroundColor Green