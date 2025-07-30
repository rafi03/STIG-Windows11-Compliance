<#
.SYNOPSIS
    Prevents autorun commands from executing to meet STIG WN11-CC-000185 requirements.
.DESCRIPTION
    Configures the default autorun behavior to prevent autorun commands from executing automatically.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-CC-000185
#>

# Registry path for AutoRun policies
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"

try {
    Write-Host "Configuring autorun behavior to prevent autorun commands..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Set autorun behavior to "Do not execute any autorun commands"
    # Value 1 = Do not execute any autorun commands
    Set-ItemProperty -Path $RegistryPath -Name "NoAutorun" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "NoAutorun" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.NoAutorun -eq 1) {
        Write-Host "✓ Autorun commands successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000185 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable autorun commands" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring autorun settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "System is now protected from automatic execution of autorun commands." -ForegroundColor Green