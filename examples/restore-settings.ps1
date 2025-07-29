<#
.SYNOPSIS
    Restores system settings from STIG backup
.DESCRIPTION
    Restores registry settings and system configuration from a backup created by backup-settings.ps1.
    Use this script if STIG changes cause system issues and need to be reverted.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
.PARAMETER BackupPath
    Path to the backup directory created by backup-settings.ps1
.USAGE
    Run to restore settings from backup
    Example syntax:
    PS C:\> .\restore-settings.ps1 -BackupPath "C:\STIGBackups\STIG_Backup_20250729_143022"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$BackupPath
)

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "ERROR: This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Please right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Validate backup path
if (!(Test-Path $BackupPath)) {
    Write-Host "ERROR: Backup path does not exist: $BackupPath" -ForegroundColor Red
    Write-Host "Please verify the backup path and try again." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "=" * 60 -ForegroundColor Red
Write-Host "WINDOWS 11 STIG SETTINGS RESTORE" -ForegroundColor Red
Write-Host "=" * 60 -ForegroundColor Red
Write-Host "Backup Location: $BackupPath" -ForegroundColor Cyan
Write-Host "Restore Date: $(Get-Date)" -ForegroundColor Gray
Write-Host ""

Write-Host "WARNING: This will restore system settings to their pre-STIG state!" -ForegroundColor Yellow
Write-Host "This action should only be performed if STIG changes caused system issues." -ForegroundColor Yellow
Write-Host ""

# Confirm restore operation
$Confirmation = Read-Host "Are you sure you want to restore settings? (Type 'YES' to continue)"
if ($Confirmation -ne "YES") {
    Write-Host "Restore operation cancelled by user." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Starting restore operation..." -ForegroundColor Yellow
Write-Host ""

# Registry files to restore
$RegistryFiles = @(
    @{
        Name = "Event Logs Configuration"
        File = "EventLogs.reg"
    },
    @{
        Name = "Windows Policies"
        File = "WindowsPolicies.reg"
    },
    @{
        Name = "Explorer Policies"
        File = "ExplorerPolicies.reg"
    },
    @{
        Name = "LSA Security Settings"
        File = "LSASettings.reg"
    },
    @{
        Name = "Internet Explorer Policies"
        File = "IEPolicies.reg"
    },
    @{
        Name = "PowerShell Policies"
        File = "PowerShellPolicies.reg"
    },
    @{
        Name = "Windows Installer Policies"
        File = "InstallerPolicies.reg"
    },
    @{
        Name = "System Policies"
        File = "SystemPolicies.reg"
    }
)

$RestoreSummary = @()
$SuccessfulRestores = 0
$FailedRestores = 0

# Restore registry files
foreach ($RegFile in $RegistryFiles) {
    $RestoreFile = Join-Path $BackupPath $RegFile.File
    
    Write-Host "Restoring: $($RegFile.Name)..." -ForegroundColor Yellow
    
    if (!(Test-Path $RestoreFile)) {
        Write-Host "  ⚠ Backup file not found: $($RegFile.File)" -ForegroundColor Yellow
        $RestoreSummary += [PSCustomObject]@{
            Component = $RegFile.Name
            Status = "Skipped"
            File = $RegFile.File
            Error = "Backup file not found"
        }
        continue
    }
    
    try {
        # Use reg.exe to import registry
        $Result = & reg.exe import "$RestoreFile" 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Successfully restored $($RegFile.Name)" -ForegroundColor Green
            $RestoreSummary += [PSCustomObject]@{
                Component = $RegFile.Name
                Status = "Success"
                File = $RegFile.File
                Error = $null
            }
            $SuccessfulRestores++
        } else {
            throw "Registry import failed with exit code $LASTEXITCODE"
        }
    } catch {
        Write-Host "  ✗ Failed to restore $($RegFile.Name): $($_.Exception.Message)" -ForegroundColor Red
        $RestoreSummary += [PSCustomObject]@{
            Component = $RegFile.Name
            Status = "Failed"
            File = $RegFile.File
            Error = $_.Exception.Message
        }
        $FailedRestores++
    }
}

# Restore audit policy
Write-Host ""
Write-Host "Restoring Audit Policy settings..." -ForegroundColor Yellow
$AuditBackupFile = Join-Path $BackupPath "AuditPolicy_Backup.csv"

if (Test-Path $AuditBackupFile) {
    try {
        & auditpol.exe /restore /file:"$AuditBackupFile" 2>&1 | Out-Null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ Audit policy successfully restored" -ForegroundColor Green
            $SuccessfulRestores++
        } else {
            Write-Host "  ✗ Failed to restore audit policy (exit code: $LASTEXITCODE)" -ForegroundColor Red
            $FailedRestores++
        }
    } catch {
        Write-Host "  ✗ Error restoring audit policy: $($_.Exception.Message)" -ForegroundColor Red
        $FailedRestores++
    }
} else {
    Write-Host "  ⚠ Audit policy backup file not found" -ForegroundColor Yellow
}

# Force Group Policy refresh
Write-Host ""
Write-Host "Refreshing Group Policy..." -ForegroundColor Yellow
try {
    & gpupdate.exe /force 2>&1 | Out-Null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  ✓ Group Policy refreshed successfully" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Group Policy refresh completed with warnings" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ✗ Error refreshing Group Policy: $($_.Exception.Message)" -ForegroundColor Red
}

# Create restore log
Write-Host ""
Write-Host "Creating restore log..." -ForegroundColor Yellow
try {
    $LogContent = @"
WINDOWS 11 STIG SETTINGS RESTORE LOG
====================================

Restore Date: $(Get-Date)
Backup Source: $BackupPath
Computer: $env:COMPUTERNAME
User: $env:USERNAME

RESTORE SUMMARY:
Total Components: $($SuccessfulRestores + $FailedRestores)
Successfully Restored: $SuccessfulRestores
Failed Restores: $FailedRestores

DETAILED RESULTS:
$($RestoreSummary | Format-Table -AutoSize | Out-String)

NEXT STEPS:
1. Restart the computer to ensure all changes take effect
2. Run compliance-check.ps1 to verify restore was successful
3. Test critical system functions
4. Monitor system for stability

WARNING: If issues persist after restore:
- Boot to Safe Mode
- Run System File Checker: sfc /scannow
- Consider System Restore from Windows Recovery
- Contact system administrator for assistance

"@
    
    $LogFile = Join-Path $BackupPath "RestoreLog_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"
    $LogContent | Out-File -FilePath $LogFile -Encoding UTF8
    Write-Host "  ✓ Restore log saved to: $LogFile" -ForegroundColor Green
} catch {
    Write-Host "  ✗ Error creating restore log: $($_.Exception.Message)" -ForegroundColor Red
}

# Display summary
Write-Host ""
Write-Host "=" * 60 -ForegroundColor Red
Write-Host "RESTORE SUMMARY" -ForegroundColor Red
Write-Host "=" * 60 -ForegroundColor Red

Write-Host "Total Components: $($SuccessfulRestores + $FailedRestores)" -ForegroundColor Gray
Write-Host "Successfully Restored: $SuccessfulRestores" -ForegroundColor Green
Write-Host "Failed Restores: $FailedRestores" -ForegroundColor Red

if ($FailedRestores -eq 0) {
    Write-Host "✓ Restore operation completed successfully!" -ForegroundColor Green
} else {
    Write-Host "⚠ Restore completed with $FailedRestores failures" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "RESTORE DETAILS:" -ForegroundColor Cyan
$RestoreSummary | Format-Table -AutoSize

Write-Host ""
Write-Host "CRITICAL NEXT STEPS:" -ForegroundColor Yellow
Write-Host "1. RESTART the computer immediately" -ForegroundColor Red
Write-Host "2. After restart, run: .\compliance-check.ps1" -ForegroundColor Gray
Write-Host "3. Test critical applications and services" -ForegroundColor Gray
Write-Host "4. Monitor system stability for 24-48 hours" -ForegroundColor Gray

if ($FailedRestores -gt 0) {
    Write-Host ""
    Write-Host "FAILED RESTORES DETECTED:" -ForegroundColor Red
    $RestoreSummary | Where-Object {$_.Status -eq "Failed"} | ForEach-Object {
        Write-Host "• $($_.Component): $($_.Error)" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Manual intervention may be required for failed components." -ForegroundColor Yellow
    Write-Host "Consult RESTORE_INSTRUCTIONS.txt in the backup directory for manual steps." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "SYSTEM RESTART REQUIRED!" -ForegroundColor Red
$RestartConfirmation = Read-Host "Restart computer now? (Y/N)"
if ($RestartConfirmation -eq "Y" -or $RestartConfirmation -eq "y") {
    Write-Host "Restarting computer in 10 seconds..." -ForegroundColor Yellow
    Write-Host "Press Ctrl+C to cancel restart" -ForegroundColor Gray
    Start-Sleep -Seconds 10
    Restart-Computer -Force
} else {
    Write-Host "Please restart the computer manually to complete the restore process." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Restore operation completed at $(Get-Date)" -ForegroundColor Gray
Write-Host "=" * 60 -ForegroundColor Red