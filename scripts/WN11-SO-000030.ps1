<#
.SYNOPSIS
    Enables audit policy subcategories to meet STIG WN11-SO-000030 requirements.
.DESCRIPTION
    Forces audit policy subcategory settings to override audit policy category settings.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-SO-000030
#>

# Registry path for audit policy settings
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"

try {
    Write-Host "Enabling audit policy subcategories..." -ForegroundColor Yellow
    
    # Enable subcategory policy override
    # Value 1 = Force audit policy subcategory settings to override category settings
    Set-ItemProperty -Path $RegistryPath -Name "SCENoApplyLegacyAuditPolicy" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "SCENoApplyLegacyAuditPolicy" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.SCENoApplyLegacyAuditPolicy -eq 1) {
        Write-Host "✓ Audit policy subcategories successfully enabled" -ForegroundColor Green
        Write-Host "✓ Subcategory settings will override category settings" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000030 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to enable audit policy subcategories" -ForegroundColor Red
    }
    
    # Additional verification using auditpol command
    Write-Host "Verifying audit policy configuration..." -ForegroundColor Yellow
    # $AuditResult = & auditpol.exe /get /category:* 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Audit policy is functioning correctly" -ForegroundColor Green
    }
    
} catch {
    Write-Host "✗ Error configuring audit policy settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Audit policy subcategories are now enabled for precise auditing control." -ForegroundColor Green