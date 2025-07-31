<#
.SYNOPSIS
    Configures smart card removal behavior to meet STIG WN11-SO-000095 requirements.
.DESCRIPTION
    Sets the system to lock the workstation when a smart card is removed according to 
    STIG specifications. Uses the correct registry path and value type.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.1
    STIG-ID         : WN11-SO-000095
#>

# CORRECT REGISTRY PATH PER STIG REQUIREMENT
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

try {
    Write-Host "Configuring smart card removal behavior..." -ForegroundColor Yellow
    
    # Verify Winlogon registry path exists
    if (-not (Test-Path $RegistryPath)) {
        Write-Host "✗ Required registry path not found: $RegistryPath" -ForegroundColor Red
        Write-Host "Creating registry path..." -ForegroundColor Yellow
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Configure smart card removal behavior
    # Value "1" = Lock Workstation (recommended)
    # Value "2" = Force Logoff (more secure)
    $DesiredValue = "1"  # Change to "2" if Force Logoff is required

    # Set registry value with CORRECT VALUE TYPE (REG_SZ)
    Set-ItemProperty -Path $RegistryPath -Name "SCRemoveOption" -Value $DesiredValue -Type String
    
    # Verify the setting
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "SCRemoveOption" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.SCRemoveOption -eq $DesiredValue) {
        Write-Host "✓ Smart card removal behavior set to '$(
            if ($DesiredValue -eq '1') {'Lock Workstation'} else {'Force Logoff'}
        )'" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000095 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to configure smart card removal behavior" -ForegroundColor Red
        # FIXED: Use PowerShell 5.1 compatible syntax
        $CurrentValue = if ($CurrentSetting.SCRemoveOption) { $CurrentSetting.SCRemoveOption } else { 'Not configured' }
        Write-Host "Current setting: $CurrentValue" -ForegroundColor Red
    }
    
    # Display STIG verification command
    Write-Host "`nVerify with:" -ForegroundColor Cyan
    Write-Host "Get-ItemProperty -Path '$RegistryPath' | Select-Object SCRemoveOption" -ForegroundColor White

} catch {
    Write-Host "✗ Critical error: $($_.Exception.Message)" -ForegroundColor Red
}

# System impact notice
Write-Host "`n[!] SYSTEM IMPACT:" -ForegroundColor Magenta
Write-Host " - Smart card removal will now trigger workstation lock" -ForegroundColor Yellow
Write-Host " - No reboot required - changes take effect immediately" -ForegroundColor Green