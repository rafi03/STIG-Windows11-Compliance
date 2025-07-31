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
    Last Modified   : 2025-07-30
    Version         : 2.0
.USAGE
    Run to check current STIG compliance status
    Example syntax:
    PS C:\> .\compliance-check.ps1
#>

# STIG compliance settings to check (All 40 items from README)
$STIGSettings = @(
    # Account Policies
    @{
        STIG = "WN11-AC-000005"
        Description = "Account Lockout Duration"
        Type = "Command"
        Command = "net accounts"
        Expected = "Lockout duration.*15"
        Severity = "CAT II"
        Category = "Account"
    },
    @{
        STIG = "WN11-AC-000010"
        Description = "Account Lockout Threshold"
        Type = "Command"
        Command = "net accounts"
        Expected = "Lockout threshold.*3"
        Severity = "CAT II"
        Category = "Account"
    },
    @{
        STIG = "WN11-AC-000015"
        Description = "Reset Account Lockout Counter"
        Type = "Command"
        Command = "net accounts"
        Expected = "Lockout observation window.*15"
        Severity = "CAT II"
        Category = "Account"
    },
    @{
        STIG = "WN11-AC-000020"
        Description = "Password History"
        Type = "Command"
        Command = "net accounts"
        Expected = "Length of password history maintained.*24"
        Severity = "CAT II"
        Category = "Account"
    },
    @{
        STIG = "WN11-AC-000030"
        Description = "Minimum Password Age"
        Type = "Command"
        Command = "net accounts"
        Expected = "Minimum password age.*1"
        Severity = "CAT II"
        Category = "Account"
    },
    @{
        STIG = "WN11-AC-000035"
        Description = "Minimum Password Length"
        Type = "Command"
        Command = "net accounts"
        Expected = "Minimum password length.*14"
        Severity = "CAT II"
        Category = "Account"
    },
    @{
        STIG = "WN11-AC-000040"
        Description = "Password Complexity"
        Type = "Registry"
        Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
        Name = "PasswordComplexity"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
        Category = "Account"
    },
    # Audit Policies
    @{
        STIG = "WN11-AU-000005"
        Description = "Audit Credential Validation Failures"
        Type = "Audit"
        Subcategory = "Credential Validation"
        Expected = "Failure"
        Severity = "CAT II"
        Category = "Audit"
    },
    @{
        STIG = "WN11-AU-000010"
        Description = "Audit Credential Validation Success"
        Type = "Audit"
        Subcategory = "Credential Validation"
        Expected = "Success"
        Severity = "CAT II"
        Category = "Audit"
    },
    @{
        STIG = "WN11-AU-000050"
        Description = "Audit Process Creation"
        Type = "Audit"
        Subcategory = "Process Creation"
        Expected = "Success"
        Severity = "CAT II"
        Category = "Audit"
    },
    @{
        STIG = "WN11-AU-000060"
        Description = "Audit Group Membership"
        Type = "Audit"
        Subcategory = "Group Membership"
        Expected = "Success"
        Severity = "CAT II"
        Category = "Audit"
    },
    @{
        STIG = "WN11-AU-000500"
        Description = "Application Event Log Size"
        Type = "Registry"
        Path = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application"
        Name = "MaxSize"
        ExpectedValue = 32768
        Operator = "ge"
        Severity = "CAT II"
        Category = "Audit"
    },
    @{
        STIG = "WN11-AU-000505"
        Description = "Security Event Log Size"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"
        Name = "MaxSize"
        ExpectedValue = 1024000
        Operator = "ge"
        Severity = "CAT II"
        Category = "Audit"
    },
    @{
        STIG = "WN11-AU-000510"
        Description = "System Event Log Size"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"
        Name = "MaxSize"
        ExpectedValue = 32768
        Operator = "ge"
        Severity = "CAT II"
        Category = "Audit"
    },
    # Configuration Settings
    @{
        STIG = "WN11-CC-000005"
        Description = "Prevent Lock Screen Camera Access"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
        Name = "NoLockScreenCamera"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000180"
        Description = "Disable Autoplay for Non-Volume Devices"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
        Name = "NoAutoplayfornonVolume"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT I"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000185"
        Description = "Prevent Autorun Commands"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Name = "NoAutorun"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT I"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000190"
        Description = "Disable Autoplay for All Drives"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
        Name = "NoDriveTypeAutoRun"
        ExpectedValue = 255
        Operator = "eq"
        Severity = "CAT I"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000197"
        Description = "Turn Off Microsoft Consumer Experiences"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"
        Name = "DisableWindowsConsumerFeatures"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT III"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000210"
        Description = "Enable Windows Defender SmartScreen"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"
        Name = "EnableSmartScreen"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000270"
        Description = "Prevent Saving Passwords in RDP"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
        Name = "DisablePasswordSaving"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000280"
        Description = "Always Prompt for RDP Password"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"
        Name = "fPromptForPassword"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000295"
        Description = "Prevent RSS Feed Attachments"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds"
        Name = "DisableEnclosureDownload"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000305"
        Description = "Disable Encrypted File Indexing"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
        Name = "AllowIndexingEncryptedStoresOrItems"
        ExpectedValue = 0
        Operator = "eq"
        Severity = "CAT II"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000310"
        Description = "Prevent User Installation Control"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
        Name = "EnableUserControl"
        ExpectedValue = 0
        Operator = "eq"
        Severity = "CAT II"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000315"
        Description = "Disable Elevated Privileges Installation"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
        Name = "AlwaysInstallElevated"
        ExpectedValue = 0
        Operator = "eq"
        Severity = "CAT I"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000326"
        Description = "Enable PowerShell Script Block Logging"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"
        Name = "EnableScriptBlockLogging"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000327"
        Description = "Enable PowerShell Transcription"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"
        Name = "EnableTranscripting"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
        Category = "Config"
    },
    @{
        STIG = "WN11-CC-000330"
        Description = "Disable WinRM Basic Authentication"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"
        Name = "AllowBasic"
        ExpectedValue = 0
        Operator = "eq"
        Severity = "CAT I"
        Category = "Config"
    },
    # Security Options
    @{
        STIG = "WN11-SO-000005"
        Description = "Disable Built-in Administrator Account"
        Type = "LocalUser"
        Expected = "Disabled"
        Severity = "CAT I"
        Category = "Security"
    },
    @{
        STIG = "WN11-SO-000025"
        Description = "Rename Built-in Guest Account"
        Type = "LocalUser"
        Expected = "Renamed"
        Severity = "CAT II"
        Category = "Security"
    },
    @{
        STIG = "WN11-SO-000030"
        Description = "Enable Audit Policy Subcategories"
        Type = "Registry"
        Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
        Name = "SCENoApplyLegacyAuditPolicy"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
        Category = "Security"
    },
    @{
        STIG = "WN11-SO-000095"
        Description = "Smart Card Removal Behavior"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
        Name = "ScRemoveOption"
        ExpectedValue = "1"
        Operator = "eq"
        Severity = "CAT II"
        Category = "Security"
    },
    @{
        STIG = "WN11-SO-000230"
        Description = "Use FIPS Compliant Algorithms"
        Type = "Registry"
        Path = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"
        Name = "Enabled"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT II"
        Category = "Security"
    },
    # User Configuration
    @{
        STIG = "WN11-UC-000015"
        Description = "Turn Off Toast Notifications on Lock Screen"
        Type = "Registry"
        Path = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
        Name = "NoToastApplicationNotificationOnLockScreen"
        ExpectedValue = 1
        Operator = "eq"
        Severity = "CAT III"
        Category = "User Config"
    }
)

# Function to check registry-based STIG setting
function Test-RegistrySTIGSetting {
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
            Category = $Setting.Category
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
            Category = $Setting.Category
            Status = "NOT CONFIGURED"
            ActualValue = "N/A"
            ExpectedValue = $Setting.ExpectedValue
            Path = $Setting.Path
            Name = $Setting.Name
            Error = $_.Exception.Message
        }
    }
}

# Function to check command-based STIG setting
function Test-CommandSTIGSetting {
    param($Setting)
    
    try {
        $Output = & $Setting.Command.Split()[0] $Setting.Command.Split()[1..100] 2>&1
        $OutputString = $Output -join "`n"
        
        $IsCompliant = $OutputString -match $Setting.Expected
        
        return @{
            STIG = $Setting.STIG
            Description = $Setting.Description
            Severity = $Setting.Severity
            Category = $Setting.Category
            Status = if ($IsCompliant) { "COMPLIANT" } else { "NON-COMPLIANT" }
            ActualValue = ($OutputString -split "`n" | Where-Object { $_ -match $Setting.Expected.Split('.*')[0] }) -join "; "
            ExpectedValue = $Setting.Expected
            Path = $Setting.Command
            Name = "Command Output"
            Error = $null
        }
    }
    catch {
        return @{
            STIG = $Setting.STIG
            Description = $Setting.Description
            Severity = $Setting.Severity
            Category = $Setting.Category
            Status = "ERROR"
            ActualValue = "Command failed"
            ExpectedValue = $Setting.Expected
            Path = $Setting.Command
            Name = "Command Output"
            Error = $_.Exception.Message
        }
    }
}

# Function to check audit policy STIG setting
function Test-AuditSTIGSetting {
    param($Setting)
    
    try {
        $Output = & auditpol.exe /get /subcategory:"$($Setting.Subcategory)" 2>&1
        $OutputString = $Output -join "`n"
        
        $IsCompliant = $OutputString -match $Setting.Expected
        
        return @{
            STIG = $Setting.STIG
            Description = $Setting.Description
            Severity = $Setting.Severity
            Category = $Setting.Category
            Status = if ($IsCompliant) { "COMPLIANT" } else { "NON-COMPLIANT" }
            ActualValue = ($OutputString -split "`n" | Where-Object { $_ -match $Setting.Subcategory }) -join "; "
            ExpectedValue = "$($Setting.Subcategory) - $($Setting.Expected)"
            Path = "Audit Policy"
            Name = $Setting.Subcategory
            Error = $null
        }
    }
    catch {
        return @{
            STIG = $Setting.STIG
            Description = $Setting.Description
            Severity = $Setting.Severity
            Category = $Setting.Category
            Status = "ERROR"
            ActualValue = "Audit check failed"
            ExpectedValue = "$($Setting.Subcategory) - $($Setting.Expected)"
            Path = "Audit Policy"
            Name = $Setting.Subcategory
            Error = $_.Exception.Message
        }
    }
}

# Function to check local user STIG setting
function Test-LocalUserSTIGSetting {
    param($Setting)
    
    try {
        if ($Setting.STIG -eq "WN11-SO-000005") {
            # Check built-in Administrator account
            $AdminAccount = Get-LocalUser | Where-Object {$_.SID -like "*-500"}
            if ($AdminAccount) {
                $IsCompliant = -not $AdminAccount.Enabled
                return @{
                    STIG = $Setting.STIG
                    Description = $Setting.Description
                    Severity = $Setting.Severity
                    Category = $Setting.Category
                    Status = if ($IsCompliant) { "COMPLIANT" } else { "NON-COMPLIANT" }
                    ActualValue = if ($AdminAccount.Enabled) { "Enabled" } else { "Disabled" }
                    ExpectedValue = "Disabled"
                    Path = "Local Users"
                    Name = $AdminAccount.Name
                    Error = $null
                }
            }
        }
        elseif ($Setting.STIG -eq "WN11-SO-000025") {
            # Check guest account name
            $GuestAccount = Get-WmiObject Win32_UserAccount | Where-Object {$_.SID -like "*-501"}
            if ($GuestAccount) {
                $IsCompliant = $GuestAccount.Name -ne "Guest"
                return @{
                    STIG = $Setting.STIG
                    Description = $Setting.Description
                    Severity = $Setting.Severity
                    Category = $Setting.Category
                    Status = if ($IsCompliant) { "COMPLIANT" } else { "NON-COMPLIANT" }
                    ActualValue = $GuestAccount.Name
                    ExpectedValue = "Not 'Guest'"
                    Path = "Local Users"
                    Name = "Guest Account"
                    Error = $null
                }
            }
        }
        
        # Default return if account not found
        return @{
            STIG = $Setting.STIG
            Description = $Setting.Description
            Severity = $Setting.Severity
            Category = $Setting.Category
            Status = "NOT FOUND"
            ActualValue = "Account not found"
            ExpectedValue = $Setting.Expected
            Path = "Local Users"
            Name = "User Account"
            Error = "Account not found"
        }
    }
    catch {
        return @{
            STIG = $Setting.STIG
            Description = $Setting.Description
            Severity = $Setting.Severity
            Category = $Setting.Category
            Status = "ERROR"
            ActualValue = "Check failed"
            ExpectedValue = $Setting.Expected
            Path = "Local Users"
            Name = "User Account"
            Error = $_.Exception.Message
        }
    }
}

# Function to check compliance for a single setting
function Test-STIGSetting {
    param($Setting)
    
    switch ($Setting.Type) {
        "Registry" { return Test-RegistrySTIGSetting -Setting $Setting }
        "Command" { return Test-CommandSTIGSetting -Setting $Setting }
        "Audit" { return Test-AuditSTIGSetting -Setting $Setting }
        "LocalUser" { return Test-LocalUserSTIGSetting -Setting $Setting }
        default { 
            return @{
                STIG = $Setting.STIG
                Description = $Setting.Description
                Severity = $Setting.Severity
                Category = $Setting.Category
                Status = "UNKNOWN TYPE"
                ActualValue = "Unknown"
                ExpectedValue = "Unknown"
                Path = "Unknown"
                Name = "Unknown"
                Error = "Unknown test type: $($Setting.Type)"
            }
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
$ErrorCount = 0
$Results = @()

# Check each STIG setting
Write-Host "Checking $TotalSettings STIG compliance settings..." -ForegroundColor Yellow
Write-Host ""

$ProgressCount = 0
foreach ($Setting in $STIGSettings) {
    $ProgressCount++
    Write-Progress -Activity "Checking STIG Compliance" -Status "Processing $($Setting.STIG)" -PercentComplete (($ProgressCount / $TotalSettings) * 100)
    
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
        default {
            $ErrorCount++
            Write-Host "  ✗ ERROR: $($Result.Error)" -ForegroundColor Red
        }
    }
}

Write-Progress -Activity "Checking STIG Compliance" -Completed

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
Write-Host "Errors: $ErrorCount" -ForegroundColor Red
Write-Host "Compliance Percentage: $CompliancePercentage%" -ForegroundColor $(if ($CompliancePercentage -ge 90) { "Green" } elseif ($CompliancePercentage -ge 75) { "Yellow" } else { "Red" })

# Summary by category
Write-Host ""
Write-Host "COMPLIANCE BY CATEGORY:" -ForegroundColor Cyan
$CategorySummary = $Results | Group-Object Category | ForEach-Object {
    $CategoryResults = $_.Group
    $CategoryCompliant = ($CategoryResults | Where-Object {$_.Status -eq "COMPLIANT"}).Count
    $CategoryTotal = $CategoryResults.Count
    $CategoryPercentage = [math]::Round(($CategoryCompliant / $CategoryTotal) * 100, 1)
    
    [PSCustomObject]@{
        Category = $_.Name
        Total = $CategoryTotal
        Compliant = $CategoryCompliant
        Percentage = "$CategoryPercentage%"
        Status = if ($CategoryPercentage -ge 90) { "Good" } elseif ($CategoryPercentage -ge 75) { "Fair" } else { "Poor" }
    }
}

$CategorySummary | Sort-Object Category | Format-Table -AutoSize

# Detailed results table
Write-Host ""
Write-Host "DETAILED RESULTS:" -ForegroundColor Cyan
Write-Host ""

$Results | Sort-Object STIG | Format-Table -Property @(
    @{Name="STIG ID"; Expression={$_.STIG}; Width=15},
    @{Name="Category"; Expression={$_.Category}; Width=12},
    @{Name="Severity"; Expression={$_.Severity}; Width=8},
    @{Name="Status"; Expression={
        switch ($_.Status) {
            "COMPLIANT" { "✓ PASS" }
            "NON-COMPLIANT" { "✗ FAIL" }
            "NOT CONFIGURED" { "⚠ N/C" }
            default { "✗ ERR" }
        }
    }; Width=8},
    @{Name="Description"; Expression={$_.Description}; Width=35}
) -AutoSize

# Show non-compliant items
if ($NonCompliantCount -gt 0 -or $NotConfiguredCount -gt 0 -or $ErrorCount -gt 0) {
    Write-Host ""
    Write-Host "ITEMS REQUIRING ATTENTION:" -ForegroundColor Yellow
    Write-Host ""
    
    $Results | Where-Object { $_.Status -ne "COMPLIANT" } | Sort-Object Severity, STIG | ForEach-Object {
        $StatusColor = switch ($_.Status) {
            "NON-COMPLIANT" { "Red" }
            "NOT CONFIGURED" { "Yellow" }
            default { "Red" }
        }
        
        Write-Host "• $($_.STIG) [$($_.Severity)]: $($_.Description)" -ForegroundColor White
        Write-Host "  Status: $($_.Status)" -ForegroundColor $StatusColor
        if ($_.Path -and $_.Name) {
            Write-Host "  Path: $($_.Path)" -ForegroundColor Gray
            Write-Host "  Setting: $($_.Name)" -ForegroundColor Gray
        }
        Write-Host "  Expected: $($_.ExpectedValue)" -ForegroundColor Gray
        Write-Host "  Actual: $($_.ActualValue)" -ForegroundColor Gray
        if ($_.Error) {
            Write-Host "  Error: $($_.Error)" -ForegroundColor Red
        }
        Write-Host "  Remediation: Run .\STIG-ID-$($_.STIG).ps1" -ForegroundColor Cyan
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

# Priority recommendations based on severity
$CatIFailures = ($Results | Where-Object { $_.Severity -eq "CAT I" -and $_.Status -ne "COMPLIANT" }).Count
$CatIIFailures = ($Results | Where-Object { $_.Severity -eq "CAT II" -and $_.Status -ne "COMPLIANT" }).Count
$CatIIIFailures = ($Results | Where-Object { $_.Severity -eq "CAT III" -and $_.Status -ne "COMPLIANT" }).Count

if ($CatIFailures -gt 0) {
    Write-Host ""
    Write-Host "⚠️ CRITICAL: $CatIFailures Category I (High) findings detected!" -ForegroundColor Red
    Write-Host "These represent the highest security risks and should be addressed immediately." -ForegroundColor Red
}

if ($CatIIFailures -gt 0) {
    Write-Host ""
    Write-Host "⚠️ WARNING: $CatIIFailures Category II (Medium) findings detected." -ForegroundColor Yellow
    Write-Host "These should be addressed promptly to maintain security posture." -ForegroundColor Yellow
}

if ($CatIIIFailures -gt 0) {
    Write-Host ""
    Write-Host "ℹ️ INFO: $CatIIIFailures Category III (Low) findings detected." -ForegroundColor Cyan
    Write-Host "These should be addressed when convenient to improve overall compliance." -ForegroundColor Cyan
}

Write-Host ""
Write-Host "Report completed at $(Get-Date)" -ForegroundColor Gray
Write-Host "=" * 80 -ForegroundColor Cyan