<#
.SYNOPSIS
    Verifies current Windows 11 STIG compliance status
.DESCRIPTION
    Checks all registry settings modified by STIG remediation scripts and reports compliance status.
    This script provides a comprehensive compliance report without making any changes.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
.USAGE
    Run to check current STIG compliance status
    Example syntax:
    PS C:\> .\compliance-check.ps1
#>

# STIG compliance settings to check
$STIGSettings = @(
    @{
        STIG = "WN11-AU-000500"
        Description = "Application Event Log Size"
        Path = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application"
        Name = "MaxSize"
        ExpectedValue = 32768
        Operator = "ge"  # Greater than or equal
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-AU-000505"
        Description = "Security Event Log Size"
        Path = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Security"
        Name = "MaxSize"
        ExpectedValue = 1024000
        Operator = "ge"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-AU-000510"
        Description = "System Event Log Size"
        Path = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\System"
        Name = "MaxSize"
        ExpectedValue = 32768
        Operator = "ge"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-CC-000180"
        Description = "Disable Autoplay for Non-Volume Devices"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
        Name = "NoAutoplayfornonVolume"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT I"
    },
    @{
        STIG = "WN11-CC-000185"
        Description = "Prevent Autorun Commands"
        Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Name = "NoAutorun"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT I"
    },
    @{
        STIG = "WN11-CC-000190"
        Description = "Disable Autoplay for All Drives"
        Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Name = "NoDriveTypeAutoRun"
        ExpectedValue = 255
        Operator = "eq"
        Severity = "CAT I"
    },
    @{
        STIG = "WN11-CC-000197"
        Description = "Turn Off Microsoft Consumer Experiences"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        Name = "DisableWindowsConsumerFeatures"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT III"
    },
    @{
        STIG = "WN11-CC-000210"
        Description = "Enable Windows Defender SmartScreen"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
        Name = "EnableSmartScreen"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-CC-000295"
        Description = "Prevent RSS Feed Attachments"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds"
        Name = "DisableEnclosureDownload"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-CC-000305"
        Description = "Disable Encrypted File Indexing"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        Name = "AllowIndexingEncryptedStoresOrItems"
        ExpectedValue = 0
        Operator = "eq"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-CC-000310"
        Description = "Prevent User Installation Control"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
        Name = "EnableUserControl"
        ExpectedValue = 0
        Operator = "eq"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-CC-000315"
        Description = "Disable Elevated Privileges Installation"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
        Name = "AlwaysInstallElevated"
        ExpectedValue = 0
        Operator = "eq"
        Severity = "CAT I"
    },
    @{
        STIG = "WN11-CC-000326"
        Description = "Enable PowerShell Script Block Logging"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
        Name = "EnableScriptBlockLogging"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-CC-000327"
        Description = "Enable PowerShell Transcription"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
        Name = "EnableTranscripting"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-SO-000030"
        Description = "Enable Audit Policy Subcategories"
        Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
        Name = "SCENoApplyLegacyAuditPolicy"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-SO-000095"
        Description = "Smart Card Removal Behavior"
        Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        Name = "ScRemoveOption"
        ExpectedValue = "1"
        Operator = "eq"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-SO-000230"
        Description = "Use FIPS Compliant Algorithms"
        Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
        Name = "Enabled"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
    },
    @{
        STIG = "WN11-UC-000015"
        Description = "Turn Off Toast Notifications on Lock Screen"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
        Name = "NoToastApplicationNotificationOnLockScreen"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT III"
    },
    @{
        STIG = "WN11-CC-000005"
        Description = "Prevent Lock Screen Camera Access"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
        Name = "NoLockScreenCamera"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
    }
)

# Function to check compliance for a single setting
function Test-STIGSetting {
    param($Setting)
    
    try {
        $Current = Get-ItemProperty -Path $Setting.Path -Name $Setting.Name -ErrorAction Stop
        $ActualValue = $Current.($Setting.Name)
        
        $IsCompliant = switch ($Setting.Operator) {
            "eq" { $ActualValue -eq $Setting.ExpectedValue }
            "ge" { $ActualValue -ge $Setting.ExpectedValue }
            "le" { $ActualValue -le $Setting.ExpectedValue }
            "gt" { $ActualValue -gt $Setting.ExpectedValue }
            "lt" { $ActualValue -lt $Setting.ExpectedValue }
            default { $ActualValue -eq $Setting.ExpectedValue }
        }
        
        return @{
            STIG = $Setting.STIG
            Description = $Setting.Description
            Severity = $Setting.Severity
            Status = if ($IsCompliant) { "COMPLIANT" } else { "NON-COMPLIANT" }
            ActualValue = $ActualValue
            ExpectedValue = $Setting.ExpectedValue
            Path = $Setting.Path
            Name = $Setting.Name
            Error = $null
        }
    }
    catch {
        return @{
            STIG = $Setting.STIG
            Description = $Setting.Description
            Severity = $Setting.Severity
            Status = "NOT CONFIGURED"
            ActualValue = "N/A"
            ExpectedValue = $Setting.ExpectedValue
            Path = $Setting.Path
            Name = $Setting.Name
            Error = $_.Exception.Message
        }
    }
}

# Check if running as Administrator
$IsAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host "WINDOWS 11 STIG COMPLIANCE CHECK" -ForegroundColor Cyan
Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host "Date: $(Get-Date)" -ForegroundColor Gray
Write-Host "Computer: $env:COMPUTERNAME" -ForegroundColor Gray
Write-Host "User: $env:USERNAME" -ForegroundColor Gray
Write-Host "Admin Rights: $(if ($IsAdmin) { 'Yes' } else { 'No (some checks may fail)' })" -ForegroundColor Gray
Write-Host ""

# Initialize counters
$TotalSettings = $STIGSettings.Count
$CompliantCount = 0
$NonCompliantCount = 0
$NotConfiguredCount = 0
$Results = @()

# Check each STIG setting
Write-Host "Checking $TotalSettings STIG compliance settings..." -ForegroundColor Yellow
Write-Host ""

foreach ($Setting in $STIGSettings) {
    Write-Host "Checking $($Setting.STIG): $($Setting.Description)..." -ForegroundColor Gray
    
    $Result = Test-STIGSetting -Setting $Setting
    $Results += New-Object PSObject -Property $Result
    
    # Update counters
    switch ($Result.Status) {
        "COMPLIANT" { 
            $CompliantCount++
            Write-Host "  ✓ COMPLIANT" -ForegroundColor Green
        }
        "NON-COMPLIANT" { 
            $NonCompliantCount++
            Write-Host "  ✗ NON-COMPLIANT (Expected: $($Result.ExpectedValue), Actual: $($Result.ActualValue))" -ForegroundColor Red
        }
        "NOT CONFIGURED" { 
            $NotConfiguredCount++
            Write-Host "  ⚠ NOT CONFIGURED" -ForegroundColor Yellow
        }
    }
}

# Generate summary report
Write-Host ""
Write-Host "=" * 80 -ForegroundColor Cyan
Write-Host "COMPLIANCE SUMMARY" -ForegroundColor Cyan
Write-Host "=" * 80 -ForegroundColor Cyan

$CompliancePercentage = [math]::Round(($CompliantCount / $TotalSettings) * 100, 1)

Write-Host "Total Settings Checked: $TotalSettings" -ForegroundColor Gray
Write-Host "Compliant: $CompliantCount" -ForegroundColor Green
Write-Host "Non-Compliant: $NonCompliantCount" -ForegroundColor Red
Write-Host "Not Configured: $NotConfiguredCount" -ForegroundColor Yellow
Write-Host "Compliance Percentage: $CompliancePercentage%" -ForegroundColor $(if ($CompliancePercentage -ge 90) { "Green" } elseif ($CompliancePercentage -ge 75) { "Yellow" } else { "Red" })

# Detailed results table
Write-Host ""
Write-Host "DETAILED RESULTS:" -ForegroundColor Cyan
Write-Host ""

$Results | Sort-Object STIG | Format-Table -Property @(
    @{Name="STIG ID"; Expression={$_.STIG}; Width=15},
    @{Name="Severity"; Expression={$_.Severity}; Width=8},
    @{Name="Status"; Expression={
        switch ($_.Status) {
            "COMPLIANT" { "✓ PASS" }
            "NON-COMPLIANT" { "✗ FAIL" }
            "NOT CONFIGURED" { "⚠ N/C" }
        }
    }; Width=8},
    @{Name="Description"; Expression={$_.Description}; Width=40}
) -AutoSize

# Show non-compliant items
if ($NonCompliantCount -gt 0 -or $NotConfiguredCount -gt 0) {
    Write-Host ""
    Write-Host "ITEMS REQUIRING ATTENTION:" -ForegroundColor Yellow
    Write-Host ""
    
    $Results | Where-Object { $_.Status -ne "COMPLIANT" } | ForEach-Object {
        Write-Host "• $($_.STIG): $($_.Description)" -ForegroundColor White
        Write-Host "  Path: $($_.Path)" -ForegroundColor Gray
        Write-Host "  Setting: $($_.Name)" -ForegroundColor Gray
        Write-Host "  Expected: $($_.ExpectedValue)" -ForegroundColor Gray
        Write-Host "  Actual: $($_.ActualValue)" -ForegroundColor Gray
        if ($_.Error) {
            Write-Host "  Error: $($_.Error)" -ForegroundColor Red
        }
        Write-Host "  Remediation: Run .\scripts\STIG-ID-$($_.STIG).ps1" -ForegroundColor Cyan
        Write-Host ""
    }
}

# Recommendations
Write-Host "RECOMMENDATIONS:" -ForegroundColor Cyan
if ($CompliancePercentage -eq 100) {
    Write-Host "✓ Excellent! All STIG settings are compliant." -ForegroundColor Green
    Write-Host "• Continue regular compliance monitoring" -ForegroundColor Gray
    Write-Host "• Document current configuration for audit purposes" -ForegroundColor Gray
} elseif ($CompliancePercentage -ge 90) {
    Write-Host "✓ Good compliance status with minor issues." -ForegroundColor Green
    Write-Host "• Address the remaining non-compliant items" -ForegroundColor Yellow
    Write-Host "• Run: .\Run-All-STIG-Remediations.ps1 to fix all issues" -ForegroundColor Cyan
} elseif ($CompliancePercentage -ge 75) {
    Write-Host "⚠ Moderate compliance - action required." -ForegroundColor Yellow
    Write-Host "• Run STIG remediation scripts to improve compliance" -ForegroundColor Yellow
    Write-Host "• Priority: Address CAT I findings first" -ForegroundColor Red
} else {
    Write-Host "✗ Low compliance - immediate action required!" -ForegroundColor Red
    Write-Host "• Run: .\Run-All-STIG-Remediations.ps1 immediately" -ForegroundColor Red
    Write-Host "• Review and test changes in non-production environment first" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Report completed at $(Get-Date)" -ForegroundColor Gray
Write-Host "=" * 80 -ForegroundColor Cyan