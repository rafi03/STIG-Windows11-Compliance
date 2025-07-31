<#
.SYNOPSIS
    Enables Windows Defender SmartScreen to meet STIG WN11-CC-000210 requirements.
.DESCRIPTION
    Configures Windows Defender SmartScreen for File Explorer with "Warn and prevent bypass" setting.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-31
    Version         : 1.1
    STIG-ID         : WN11-CC-000210
#>

# Define the registry path required by the STIG
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System"

try {
    Write-Host "Configuring Windows Defender SmartScreen for File Explorer..." -ForegroundColor Yellow

    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }

    # Enable SmartScreen (Required by STIG)
    Set-ItemProperty -Path $RegistryPath -Name "EnableSmartScreen" -Value 1 -Type DWord -Force

    # Set SmartScreen level to "Block" / "Warn and prevent bypass" (Required by STIG)
    Set-ItemProperty -Path $RegistryPath -Name "ShellSmartScreenLevel" -Value "Block" -Type String -Force

    # --- Verification ---
    $enableSetting = (Get-ItemProperty -Path $RegistryPath -Name "EnableSmartScreen" -ErrorAction SilentlyContinue).EnableSmartScreen
    $levelSetting = (Get-ItemProperty -Path $RegistryPath -Name "ShellSmartScreenLevel" -ErrorAction SilentlyContinue).ShellSmartScreenLevel

    if ($enableSetting -eq 1 -and $levelSetting -eq "Block") {
        Write-Host "--------------------------------------------------------" -ForegroundColor DarkGray
        Write-Host "✓ SUCCESS: Windows Defender SmartScreen is enabled and set to 'Block'." -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000210 requirement satisfied." -ForegroundColor Green
    } else {
        Write-Host "--------------------------------------------------------" -ForegroundColor DarkGray
        Write-Host "✗ FAILURE: Failed to verify SmartScreen settings." -ForegroundColor Red
    }
}
catch {
    Write-Host "✗ ERROR: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "SmartScreen configuration complete." -ForegroundColor Green
