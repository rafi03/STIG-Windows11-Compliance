# Windows 11 STIG Compliance Automation

![PowerShell](https://img.shields.io/badge/PowerShell-5391FE?style=for-the-badge&logo=powershell&logoColor=white)
![Windows](https://img.shields.io/badge/Windows-0078D6?style=for-the-badge&logo=windows&logoColor=white)
![Security](https://img.shields.io/badge/Security-FF6B6B?style=for-the-badge&logo=shield&logoColor=white)
![DISA](https://img.shields.io/badge/DISA_STIG-4B0082?style=for-the-badge&logo=shield&logoColor=white)
![Tenable](https://img.shields.io/badge/Tenable-00C176?style=for-the-badge&logo=tenable&logoColor=white)

A comprehensive collection of PowerShell scripts to automate Windows 11 STIG (Security Technical Implementation Guide) compliance remediation. This repository provides ready-to-use scripts for addressing 40 common security configuration failures identified by vulnerability scanners like Tenable.

## 📋 Table of Contents

- [🎯 Overview](#-overview)
- [📚 PowerShell Basics for Beginners](#-powershell-basics-for-beginners)
- [🚀 Quick Start](#-quick-start)
- [📊 STIG Remediations](#-stig-remediations)
- [🔧 Detailed STIG Remediations](#-detailed-stig-remediations)
- [⚠️ Prerequisites](#️-prerequisites)
- [🛠️ Advanced Usage](#️-advanced-usage)
- [🔍 Troubleshooting](#-troubleshooting)
- [📈 Compliance Reporting](#-compliance-reporting)
- [🤝 Contributing](#-contributing)
- [📄 License](#-license)

## 🎯 Overview

<details>
<summary><strong>What is STIG Compliance?</strong></summary>

STIG (Security Technical Implementation Guide) compliance is crucial for maintaining secure Windows environments, especially in enterprise and government settings. This repository contains PowerShell automation scripts that remediate 40 common Windows 11 STIG compliance failures identified during security scans.

### **The Challenge**
During a routine security assessment using Tenable vulnerability scanner on our Windows 11 virtual machines, we identified 40 STIG compliance failures that required immediate remediation. Manual remediation of these findings would be time-consuming and error-prone.

### **The Solution**
This repository provides automated PowerShell scripts that:
- ✅ Remediate all 40 identified STIG findings
- ✅ Provide detailed logging and verification
- ✅ Include backup and restore capabilities
- ✅ Offer comprehensive compliance checking

### **What is STIG?**
STIG provides security configuration standards developed by DISA (Defense Information Systems Agency) to enhance the security posture of information systems. These scripts help automate the remediation of failed STIG audits, ensuring your Windows 11 systems meet stringent security requirements.

</details>

## 📚 PowerShell Basics for Beginners

If you're new to PowerShell, this section will help you understand the fundamental concepts used throughout our STIG remediation scripts.

<details>
<summary><strong>🔍 PowerShell Fundamentals</strong></summary>

### Variables
Variables in PowerShell store data for later use. They always start with a `$` symbol:

```powershell
$RequiredSizeKB = 32768        # Stores a number
$RegistryPath = "HKLM:\..."    # Stores text (a string)
$CurrentSetting = Get-Item...  # Stores the result of a command
```

**Think of variables like labeled boxes:** You put something in the box, label it, and use it later.

### Registry Paths
The Windows Registry is like a huge database where Windows stores all its settings. Registry paths are like file paths, but for this database:

```powershell
"HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"
```

**Breaking this down:**
- `HKLM:` = HKEY_LOCAL_MACHINE (the main system settings)
- `\SOFTWARE` = Software settings section
- `\Policies` = Group policy settings
- `\Microsoft\Windows\Explorer` = Specific to Windows Explorer

### Common PowerShell Commands Used in Our Scripts

#### Set-ItemProperty
**Purpose:** Changes a registry value  
**Syntax:** `Set-ItemProperty -Path [WHERE] -Name [WHAT] -Value [TO_WHAT] -Type [DATA_TYPE]`

```powershell
Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value 32768 -Type DWord
```
**Translation:** "Go to the location stored in $RegistryPath, find the setting called 'MaxSize', and change it to 32768"

#### Get-ItemProperty  
**Purpose:** Reads a registry value  
**Syntax:** `Get-ItemProperty -Path [WHERE] -Name [WHAT]`

```powershell
$CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize"
```
**Translation:** "Go to $RegistryPath, read the 'MaxSize' setting, and store the result in $CurrentSize"

#### Test-Path
**Purpose:** Check if a registry path or file exists  
**Returns:** True if it exists, False if it doesn't

```powershell
if (!(Test-Path $RegistryPath)) {
    # Path doesn't exist, create it
}
```

#### New-Item
**Purpose:** Creates new registry paths or files  
**Usage:** Often used with `-Force` to create missing parent directories

```powershell
New-Item -Path $RegistryPath -Force | Out-Null
```

### Data Types
Windows Registry uses different data types for different kinds of information:

- **DWord:** 32-bit numbers (like 1, 0, 32768, 255)
- **String:** Text values (like "Block", "Disabled")  
- **Binary:** Raw binary data (rarely used in our scripts)

### Conditional Logic (If Statements)

```powershell
if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
    # Do this if condition is true
} else {
    # Do this if condition is false
}
```

**Comparison Operators:**
- `-eq` = Equal to
- `-ne` = Not equal to  
- `-gt` = Greater than
- `-ge` = Greater than or equal to
- `-lt` = Less than
- `-le` = Less than or equal to

### Error Handling

```powershell
try {
    # Try to execute this code
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value 32768 -Type DWord
} catch {
    # If anything goes wrong, do this instead
    Write-Host "Error occurred: $($_.Exception.Message)" -ForegroundColor Red
}
```

**Why use try/catch?** Registry operations can fail due to permissions, missing paths, or other issues. This prevents our script from crashing.

### Output and Colors

```powershell
Write-Host "Success message" -ForegroundColor Green
Write-Host "Warning message" -ForegroundColor Yellow  
Write-Host "Error message" -ForegroundColor Red
Write-Host "Info message" -ForegroundColor Cyan
```

**Color coding helps users quickly understand:**
- 🟢 Green = Success/Good news
- 🟡 Yellow = Warning/Attention needed
- 🔴 Red = Error/Problem
- 🔵 Cyan = Information/Details

</details>

<details>
<summary><strong>🏗️ Understanding Our Script Structure</strong></summary>

Every STIG remediation script follows the same pattern:

### 1. Header and Documentation
```powershell
<#
.SYNOPSIS
    Brief description of what the script does
.DESCRIPTION  
    Detailed explanation
.NOTES
    Author, version, STIG ID, etc.
#>
```

### 2. Variable Declarations
```powershell
$RequiredSizeKB = 32768
$RegistryPath = "HKLM:\SYSTEM\..."
```
**Purpose:** Set up the values we'll need throughout the script

### 3. Main Logic Block with Error Handling
```powershell
try {
    # Main script logic here
} catch {
    # Error handling here
}
```

### 4. Registry Path Creation (if needed)
```powershell
if (!(Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}
```
**Purpose:** Many policy paths don't exist by default, so we create them

### 5. Apply the Security Setting
```powershell
Set-ItemProperty -Path $RegistryPath -Name "PolicyName" -Value 1 -Type DWord
```
**Purpose:** This is where we actually make the security change

### 6. Verification
```powershell
$CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "PolicyName"
if ($CurrentSetting.PolicyName -eq 1) {
    Write-Host "✓ Success!" -ForegroundColor Green
}
```
**Purpose:** Confirm our change worked correctly

### 7. User Feedback
```powershell
Write-Host "Policy has been applied successfully" -ForegroundColor Green
```
**Purpose:** Tell the user what happened and what it means

</details>

## 🚀 Quick Start

1. **Clone the repository:**
   ```powershell
   git clone https://github.com/yourusername/windows11-stig-compliance.git
   cd windows11-stig-compliance
   ```

2. **Run PowerShell as Administrator** (Required for system-level changes)

3. **Create a backup before making changes:**
   ```powershell
   .\backup-settings.ps1
   ```

4. **Execute a specific script:**
   ```powershell
   .\STIG-ID-WN11-AU-000500.ps1
   ```

5. **Or run all scripts at once:**
   ```powershell
   .\Run-All-STIG-Remediations.ps1
   ```

6. **Check compliance status:**
   ```powershell
   .\compliance-check.ps1
   ```

## 📊 STIG Remediations

This repository addresses the following 40 STIG compliance issues identified during our Tenable security scan:

<details>
<summary><strong>📋 Complete STIG Remediation List (40 Items)</strong></summary>

| STIG ID | Category | Severity | Description |
|---------|----------|----------|-------------|
| **Account Policies** ||||
| [WN11-AC-000005](#wn11-ac-000005) | Account | CAT II | Account Lockout Duration |
| [WN11-AC-000010](#wn11-ac-000010) | Account | CAT II | Account Lockout Threshold |
| [WN11-AC-000015](#wn11-ac-000015) | Account | CAT II | Reset Account Lockout Counter |
| [WN11-AC-000020](#wn11-ac-000020) | Account | CAT II | Password History |
| [WN11-AC-000030](#wn11-ac-000030) | Account | CAT II | Minimum Password Age |
| [WN11-AC-000035](#wn11-ac-000035) | Account | CAT II | Minimum Password Length |
| [WN11-AC-000040](#wn11-ac-000040) | Account | CAT II | Password Complexity |
| **Audit Policies** ||||
| [WN11-AU-000005](#wn11-au-000005) | Audit | CAT II | Audit Credential Validation Failures |
| [WN11-AU-000010](#wn11-au-000010) | Audit | CAT II | Audit Credential Validation Success |
| [WN11-AU-000050](#wn11-au-000050) | Audit | CAT II | Audit Process Creation |
| [WN11-AU-000060](#wn11-au-000060) | Audit | CAT II | Audit Group Membership |
| [WN11-AU-000500](#wn11-au-000500) | Audit | CAT II | Application Event Log Size |
| [WN11-AU-000505](#wn11-au-000505) | Audit | CAT II | Security Event Log Size |
| [WN11-AU-000510](#wn11-au-000510) | Audit | CAT II | System Event Log Size |
| **Configuration Settings** ||||
| [WN11-CC-000005](#wn11-cc-000005) | Config | CAT II | Prevent Lock Screen Camera Access |
| [WN11-CC-000180](#wn11-cc-000180) | Config | CAT I | Disable Autoplay for Non-Volume Devices |
| [WN11-CC-000185](#wn11-cc-000185) | Config | CAT I | Prevent Autorun Commands |
| [WN11-CC-000190](#wn11-cc-000190) | Config | CAT I | Disable Autoplay for All Drives |
| [WN11-CC-000197](#wn11-cc-000197) | Config | CAT III | Turn Off Microsoft Consumer Experiences |
| [WN11-CC-000210](#wn11-cc-000210) | Config | CAT II | Enable Windows Defender SmartScreen |
| [WN11-CC-000270](#wn11-cc-000270) | Config | CAT II | Prevent Saving Passwords in RDP |
| [WN11-CC-000280](#wn11-cc-000280) | Config | CAT II | Always Prompt for RDP Password |
| [WN11-CC-000295](#wn11-cc-000295) | Config | CAT II | Prevent RSS Feed Attachments |
| [WN11-CC-000305](#wn11-cc-000305) | Config | CAT II | Disable Encrypted File Indexing |
| [WN11-CC-000310](#wn11-cc-000310) | Config | CAT II | Prevent User Installation Control |
| [WN11-CC-000315](#wn11-cc-000315) | Config | CAT I | Disable Elevated Privileges Installation |
| [WN11-CC-000326](#wn11-cc-000326) | Config | CAT II | Enable PowerShell Script Block Logging |
| [WN11-CC-000327](#wn11-cc-000327) | Config | CAT II | Enable PowerShell Transcription |
| [WN11-CC-000330](#wn11-cc-000330) | Config | CAT I | Disable WinRM Basic Authentication |
| **Security Options** ||||
| [WN11-SO-000005](#wn11-so-000005) | Security | CAT I | Disable Built-in Administrator |
| [WN11-SO-000025](#wn11-so-000025) | Security | CAT II | Rename Built-in Guest Account |
| [WN11-SO-000030](#wn11-so-000030) | Security | CAT II | Enable Audit Policy Subcategories |
| [WN11-SO-000095](#wn11-so-000095) | Security | CAT II | Smart Card Removal Behavior |
| [WN11-SO-000230](#wn11-so-000230) | Security | CAT II | Use FIPS Compliant Algorithms |
| **User Configuration** ||||
| [WN11-UC-000015](#wn11-uc-000015) | User Config | CAT III | Turn Off Toast Notifications on Lock Screen |

</details>

---

## 🔧 Detailed STIG Remediations

### Account Policies

#### WN11-AC-000005
<details>
<summary><strong>Account Lockout Duration Configuration</strong></summary>

**Problem:** Account lockout duration must be configured to 15 minutes or greater to limit brute force attacks.

**Solution:** This script configures the account lockout duration to meet STIG requirements.

```powershell
<#
.SYNOPSIS
    Configures account lockout duration to meet STIG WN11-AC-000005 requirements.
.DESCRIPTION
    Sets the account lockout duration to 15 minutes or greater as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000005
#>

try {
    Write-Host "Configuring account lockout duration..." -ForegroundColor Yellow
    
    # Set lockout duration to 15 minutes
    $result = & net accounts /lockoutduration:15 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Account lockout duration successfully set to 15 minutes" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000005 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent account policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "Lockout duration"
    } else {
        Write-Host "✗ Failed to set account lockout duration" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring account lockout duration: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Locked accounts will remain locked for 15 minutes." -ForegroundColor Yellow
```

**How it works:**

**🎯 The Big Picture:**
Account lockout duration determines how long an account remains locked after reaching the lockout threshold. Setting this to 15 minutes prevents attackers from repeatedly attempting passwords while minimizing impact on legitimate users who may have forgotten their password.

**📋 Our Strategy:**
1. Use the `net accounts` command to set lockout duration
2. Verify the change was applied successfully
3. Display the current setting for confirmation

**🔍 Understanding the Command:**
```powershell
net accounts /lockoutduration:15
```
- `net accounts`: Windows command for managing account policies
- `/lockoutduration:15`: Sets lockout time to 15 minutes
- **Impact:** After 3 failed login attempts (threshold), account locks for 15 minutes

**🛡️ Security Benefits:**
- Prevents rapid-fire password guessing attacks
- Gives security team time to detect and respond to attacks
- Balances security with user convenience (not too long)

</details>

#### WN11-AC-000010
<details>
<summary><strong>Account Lockout Threshold Configuration</strong></summary>

**Problem:** Account lockout threshold must be configured to 3 or fewer invalid attempts.

**Solution:** This script sets the account lockout threshold to prevent brute force attacks.

```powershell
<#
.SYNOPSIS
    Configures account lockout threshold to meet STIG WN11-AC-000010 requirements.
.DESCRIPTION
    Sets the account lockout threshold to 3 invalid attempts as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000010
#>

try {
    Write-Host "Configuring account lockout threshold..." -ForegroundColor Yellow
    
    # Set lockout threshold to 3 attempts
    $result = & net accounts /lockoutthreshold:3 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Account lockout threshold successfully set to 3 attempts" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000010 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent account policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "Lockout threshold"
    } else {
        Write-Host "✗ Failed to set account lockout threshold" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring account lockout threshold: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Accounts will lock after 3 invalid password attempts." -ForegroundColor Yellow
```

**How it works:**
- `net accounts /lockoutthreshold:3`: Sets maximum failed attempts to 3
- After 3 wrong passwords, the account locks automatically
- Works with lockout duration to prevent password attacks
- Much more secure than the default of 10 attempts

</details>

#### WN11-AC-000015
<details>
<summary><strong>Reset Account Lockout Counter Configuration</strong></summary>

**Problem:** The reset counter for account lockout must be configured to 15 minutes or greater.

**Solution:** This script sets the lockout observation window to meet STIG requirements.

```powershell
<#
.SYNOPSIS
    Configures account lockout counter reset time to meet STIG WN11-AC-000015 requirements.
.DESCRIPTION
    Sets the reset counter time to 15 minutes as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000015
#>

try {
    Write-Host "Configuring account lockout counter reset time..." -ForegroundColor Yellow
    
    # Set lockout observation window to 15 minutes
    $result = & net accounts /lockoutwindow:15 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Account lockout counter reset time successfully set to 15 minutes" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000015 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent account policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "observation window"
    } else {
        Write-Host "✗ Failed to set lockout counter reset time" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring lockout counter: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Failed login attempts reset after 15 minutes of no activity." -ForegroundColor Yellow
```

**How it works:**
- `net accounts /lockoutwindow:15`: Sets observation window to 15 minutes
- If user enters 2 wrong passwords, then waits 15 minutes, counter resets to 0
- They get a fresh set of 3 attempts
- Prevents attackers from slowly trying passwords over time

</details>

#### WN11-AC-000020
<details>
<summary><strong>Password History Configuration</strong></summary>

**Problem:** Password history must be configured to 24 passwords remembered.

**Solution:** This script configures Windows to remember the last 24 passwords to prevent reuse.

```powershell
<#
.SYNOPSIS
    Configures password history to meet STIG WN11-AC-000020 requirements.
.DESCRIPTION
    Sets the system to remember 24 passwords as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000020
#>

try {
    Write-Host "Configuring password history..." -ForegroundColor Yellow
    
    # Set password history to 24 passwords
    $result = & net accounts /uniquepw:24 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Password history successfully set to 24 passwords" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000020 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent password policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "password history"
    } else {
        Write-Host "✗ Failed to set password history" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring password history: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Users cannot reuse their last 24 passwords." -ForegroundColor Yellow
```

**How it works:**
- `net accounts /uniquepw:24`: System remembers last 24 passwords
- Users must create unique passwords they haven't used recently
- Prevents password cycling (using Password1, Password2, etc.)
- Forces better password practices

</details>

#### WN11-AC-000030
<details>
<summary><strong>Minimum Password Age Configuration</strong></summary>

**Problem:** Minimum password age must be configured to at least 1 day.

**Solution:** This script sets the minimum time before users can change their password again.

```powershell
<#
.SYNOPSIS
    Configures minimum password age to meet STIG WN11-AC-000030 requirements.
.DESCRIPTION
    Sets minimum password age to 1 day as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000030
#>

try {
    Write-Host "Configuring minimum password age..." -ForegroundColor Yellow
    
    # Set minimum password age to 1 day
    $result = & net accounts /minpwage:1 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Minimum password age successfully set to 1 day" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000030 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent password policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "Minimum password age"
    } else {
        Write-Host "✗ Failed to set minimum password age" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring minimum password age: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Users must wait 1 day between password changes." -ForegroundColor Yellow
```

**How it works:**
- `net accounts /minpwage:1`: Users must wait 1 day to change password again
- Prevents users from quickly cycling through passwords
- Works with password history to enforce unique passwords
- Stops users from changing password 24 times to reuse old one

</details>

#### WN11-AC-000035
<details>
<summary><strong>Minimum Password Length Configuration</strong></summary>

**Problem:** Minimum password length must be configured to 14 characters.

**Solution:** This script enforces a minimum password length for stronger security.

```powershell
<#
.SYNOPSIS
    Configures minimum password length to meet STIG WN11-AC-000035 requirements.
.DESCRIPTION
    Sets minimum password length to 14 characters as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000035
#>

try {
    Write-Host "Configuring minimum password length..." -ForegroundColor Yellow
    
    # Set minimum password length to 14 characters
    $result = & net accounts /minpwlen:14 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Minimum password length successfully set to 14 characters" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AC-000035 requirement satisfied" -ForegroundColor Green
        
        # Display current settings
        Write-Host "`nCurrent password policy settings:" -ForegroundColor Cyan
        net accounts | Select-String "Minimum password length"
    } else {
        Write-Host "✗ Failed to set minimum password length" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring minimum password length: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: All passwords must be at least 14 characters long." -ForegroundColor Yellow
```

**How it works:**
- `net accounts /minpwlen:14`: Requires 14-character minimum passwords
- Longer passwords are exponentially harder to crack
- 14 characters provides strong protection against brute force
- Users need to create passphrases instead of simple passwords

</details>

#### WN11-AC-000040
<details>
<summary><strong>Password Complexity Configuration</strong></summary>

**Problem:** Password complexity must be enforced to require mixed character types.

**Solution:** This script enables password complexity requirements system-wide.

```powershell
<#
.SYNOPSIS
    Enables password complexity to meet STIG WN11-AC-000040 requirements.
.DESCRIPTION
    Configures system to require complex passwords with multiple character types.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AC-000040
#>

try {
    Write-Host "Enabling password complexity requirements..." -ForegroundColor Yellow
    
    # Create temporary security policy file
    $tempFile = "$env:TEMP\secpol.cfg"
    
    # Export current security policy
    $exportResult = & secedit /export /cfg $tempFile /quiet 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        # Read and modify the policy file
        $content = Get-Content $tempFile
        $content = $content -replace "PasswordComplexity = 0", "PasswordComplexity = 1"
        $content | Set-Content $tempFile
        
        # Apply the modified policy
        $importResult = & secedit /configure /db secedit.sdb /cfg $tempFile /areas SECURITYPOLICY /quiet 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Password complexity successfully enabled" -ForegroundColor Green
            Write-Host "✓ STIG WN11-AC-000040 requirement satisfied" -ForegroundColor Green
            
            Write-Host "`nPassword complexity requirements:" -ForegroundColor Cyan
            Write-Host "• Must contain characters from 3 of 4 categories:" -ForegroundColor Gray
            Write-Host "  - Uppercase letters (A-Z)" -ForegroundColor Gray
            Write-Host "  - Lowercase letters (a-z)" -ForegroundColor Gray
            Write-Host "  - Numbers (0-9)" -ForegroundColor Gray
            Write-Host "  - Special characters (!@#$%^&*)" -ForegroundColor Gray
        } else {
            Write-Host "✗ Failed to apply password complexity policy" -ForegroundColor Red
        }
    } else {
        Write-Host "✗ Failed to export security policy" -ForegroundColor Red
    }
    
    # Clean up
    if (Test-Path $tempFile) {
        Remove-Item $tempFile -Force
    }
} catch {
    Write-Host "✗ Error configuring password complexity: $($_.Exception.Message)" -ForegroundColor Red
}
```

**How it works:**

**🎯 The Big Picture:**
Password complexity ensures passwords contain a mix of character types, making them much harder to guess or crack. Combined with the 14-character minimum length, this creates very strong password requirements.

**📋 Our Strategy:**
1. Export current security policy to a temporary file
2. Modify the PasswordComplexity setting from 0 (off) to 1 (on)
3. Import the modified policy back into Windows
4. Clean up temporary files

**🔍 Understanding the Process:**
```powershell
secedit /export /cfg $tempFile /quiet
```
- `secedit`: Windows security configuration editor
- `/export`: Exports current settings
- `/cfg $tempFile`: Saves to our temporary file
- `/quiet`: Runs without user prompts

**🛡️ Security Impact:**
- Passwords must use 3 of 4 character types
- Prevents simple passwords like "password123"
- Forces creation of strong passwords like "MyP@ssw0rd2024!"
- Dramatically increases password strength

</details>

### Audit Policies

#### WN11-AU-000005
<details>
<summary><strong>Audit Credential Validation Failures</strong></summary>

**Problem:** Failed credential validation attempts must be audited for security monitoring.

**Solution:** This script enables auditing of failed login attempts.

```powershell
<#
.SYNOPSIS
    Enables auditing of credential validation failures to meet STIG WN11-AU-000005 requirements.
.DESCRIPTION
    Configures system to log all failed authentication attempts.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AU-000005
#>

try {
    Write-Host "Enabling audit of credential validation failures..." -ForegroundColor Yellow
    
    # Enable failure auditing for credential validation
    $result = & auditpol /set /subcategory:"Credential Validation" /failure:enable 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Credential validation failure auditing successfully enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000005 requirement satisfied" -ForegroundColor Green
        
        # Display current audit settings
        Write-Host "`nCurrent audit settings for Credential Validation:" -ForegroundColor Cyan
        auditpol /get /subcategory:"Credential Validation"
    } else {
        Write-Host "✗ Failed to enable credential validation failure auditing" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring audit policy: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Failed login attempts will be logged in Security event log." -ForegroundColor Yellow
```

**How it works:**
- `auditpol /set /subcategory:"Credential Validation" /failure:enable`: Turns on failure logging
- Every failed login attempt gets recorded in Security log
- Helps detect brute force attacks and unauthorized access attempts
- Critical for security incident investigation

</details>

#### WN11-AU-000010
<details>
<summary><strong>Audit Credential Validation Success</strong></summary>

**Problem:** Successful credential validation must be audited for compliance.

**Solution:** This script enables auditing of successful login attempts.

```powershell
<#
.SYNOPSIS
    Enables auditing of credential validation success to meet STIG WN11-AU-000010 requirements.
.DESCRIPTION
    Configures system to log all successful authentication attempts.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AU-000010
#>

try {
    Write-Host "Enabling audit of credential validation success..." -ForegroundColor Yellow
    
    # Enable success auditing for credential validation
    $result = & auditpol /set /subcategory:"Credential Validation" /success:enable 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Credential validation success auditing successfully enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000010 requirement satisfied" -ForegroundColor Green
        
        # Display current audit settings
        Write-Host "`nCurrent audit settings for Credential Validation:" -ForegroundColor Cyan
        auditpol /get /subcategory:"Credential Validation"
    } else {
        Write-Host "✗ Failed to enable credential validation success auditing" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring audit policy: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Successful logins will be logged in Security event log." -ForegroundColor Yellow
```

**How it works:**
- Records every successful login to the system
- Creates an audit trail of who accessed the system and when
- Essential for compliance and forensic analysis
- Helps identify unusual login patterns

</details>

#### WN11-AU-000050
<details>
<summary><strong>Audit Process Creation</strong></summary>

**Problem:** Process creation events must be audited to track program execution.

**Solution:** This script enables detailed process creation auditing.

```powershell
<#
.SYNOPSIS
    Enables process creation auditing to meet STIG WN11-AU-000050 requirements.
.DESCRIPTION
    Configures system to log when programs and processes are started.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AU-000050
#>

try {
    Write-Host "Enabling process creation auditing..." -ForegroundColor Yellow
    
    # Enable success auditing for process creation
    $result = & auditpol /set /subcategory:"Process Creation" /success:enable 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Process creation auditing successfully enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000050 requirement satisfied" -ForegroundColor Green
        
        # Enable command line in process creation events
        Write-Host "Enabling command line logging in process creation events..." -ForegroundColor Yellow
        
        $regPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit"
        if (!(Test-Path $regPath)) {
            New-Item -Path $regPath -Force | Out-Null
        }
        
        Set-ItemProperty -Path $regPath -Name "ProcessCreationIncludeCmdLine_Enabled" -Value 1 -Type DWord
        
        Write-Host "✓ Command line logging enabled for process creation" -ForegroundColor Green
        
        # Display current audit settings
        Write-Host "`nCurrent audit settings for Process Creation:" -ForegroundColor Cyan
        auditpol /get /subcategory:"Process Creation"
    } else {
        Write-Host "✗ Failed to enable process creation auditing" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring audit policy: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: All process launches will be logged with command line details." -ForegroundColor Yellow
```

**How it works:**
- Logs every program that starts on the system
- Includes command line arguments for forensic analysis
- Critical for detecting malware execution
- Helps track suspicious activity and lateral movement

</details>

#### WN11-AU-000060
<details>
<summary><strong>Audit Group Membership</strong></summary>

**Problem:** Group membership must be included in logon events for security tracking.

**Solution:** This script enables group membership auditing in user logons.

```powershell
<#
.SYNOPSIS
    Enables group membership auditing to meet STIG WN11-AU-000060 requirements.
.DESCRIPTION
    Configures system to include group membership information in logon events.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-AU-000060
#>

try {
    Write-Host "Enabling group membership auditing..." -ForegroundColor Yellow
    
    # Enable success auditing for group membership
    $result = & auditpol /set /subcategory:"Group Membership" /success:enable 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Group membership auditing successfully enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000060 requirement satisfied" -ForegroundColor Green
        
        # Display current audit settings
        Write-Host "`nCurrent audit settings for Group Membership:" -ForegroundColor Cyan
        auditpol /get /subcategory:"Group Membership"
        
        Write-Host "`nGroup membership info will be included in Event ID 4624 (Logon)" -ForegroundColor Cyan
    } else {
        Write-Host "✗ Failed to enable group membership auditing" -ForegroundColor Red
        Write-Host "Error: $result" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring audit policy: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: User group memberships will be logged during authentication." -ForegroundColor Yellow
```

**How it works:**
- Records what security groups users belong to when they log in
- Helps track privilege escalation and unauthorized group changes
- Essential for compliance reporting
- Makes it easier to investigate security incidents

</details>

#### WN11-AU-000500
<details>
<summary><strong>Application Event Log Size Configuration</strong></summary>

**Problem:** The Application event log size must be configured to 32768 KB or greater to ensure adequate logging capacity.

**Solution:** This script configures the Windows Application event log maximum size to meet STIG requirements.

```powershell
<#
.SYNOPSIS
    Configures the Application event log size to meet STIG WN11-AU-000500 requirements.
.DESCRIPTION
    Sets the maximum Application event log size to 32768 KB (32 MB) or greater as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-AU-000500
#>

# Define the minimum required log size in KB
$RequiredSizeKB = 32768

# Registry path for Application event log settings
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application"

try {
    Write-Host "Configuring Application Event Log size..." -ForegroundColor Yellow
    
    # Set the maximum log file size
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord
    
    # Verify the setting was applied
    $CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue
    
    if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
        Write-Host "✓ Application Event Log size successfully set to $($CurrentSize.MaxSize) KB" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000500 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to set Application Event Log size" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring Application Event Log: $($_.Exception.Message)" -ForegroundColor Red
}
```

**How It Works**

**🎯 The Big Picture**
Windows stores event logs (like Application, Security, System) in files that have size limits. If these logs are too small, important security events might get overwritten before administrators can review them. The STIG requires the Application log to be at least **32 MB** to ensure adequate log retention.

**📋 Our Strategy**
This script follows a simple and robust strategy:

1.  Define the required log size (32 MB = 32768 KB).
2.  Locate the specific Windows Registry **policy** that controls the log size.
3.  Check if the registry path exists, and create it if it doesn't to prevent errors.
4.  Set the registry value to meet the STIG requirement.
5.  Verify the change was successful.
6.  Wrap the entire operation in error handling.

</details>

#### WN11-AU-000505
<details>
<summary><strong>Security Event Log Size Configuration</strong></summary>

**Problem:** The Security event log size must be configured to 1024000 KB or greater for adequate security logging.

**Solution:** This script configures the Windows Security event log maximum size to meet STIG requirements.

```powershell
<#
.SYNOPSIS
    Configures the Security event log size to meet STIG WN11-AU-000505 requirements.
.DESCRIPTION
    Sets the maximum Security event log size to 1024000 KB (1 GB) as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.1
    STIG-ID         : WN11-AU-000505
#>

# Define the minimum required log size in KB (1 GB)
$RequiredSizeKB = 1024000

# Correct STIG registry path
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\Security"

try {
    Write-Host "Configuring Security Event Log size (STIG WN11-AU-000505)..." -ForegroundColor Yellow

    # Ensure the path exists
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Set the maximum log file size
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord

    # Verify the setting was applied
    $CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue

    if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
        Write-Host "✓ Security Event Log size successfully set to $($CurrentSize.MaxSize) KB" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000505 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to set Security Event Log size" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring Security Event Log: $($_.Exception.Message)" -ForegroundColor Red
}
```

**How it works:**

**🎯 The Big Picture:**
Security event logs are the most critical logs in Windows — they track login attempts, privilege escalations, audit policy changes, and other sensitive security activities. The **STIG WN11-AU-000505** mandates a minimum log size of **1 GB (1024000 KB)** to ensure these high-volume logs retain enough history for forensic investigation and incident response.

</details>

#### WN11-AU-000510
<details>
<summary><strong>System Event Log Size Configuration</strong></summary>

**Problem:** The System event log size must be configured to 32768 KB or greater.

**Solution:** This script configures the Windows System event log maximum size to meet STIG requirements.

```powershell
<#
.SYNOPSIS
    Configures the System event log size to meet STIG WN11-AU-000510 requirements.
.DESCRIPTION
    Sets the maximum System event log size to 32768 KB (32 MB) as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.1
    STIG-ID         : WN11-AU-000510
#>

# Define the minimum required log size in KB
$RequiredSizeKB = 32768

# Correct registry path for STIG compliance
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\EventLog\System"

try {
    Write-Host "Configuring System Event Log size (STIG WN11-AU-000510)..." -ForegroundColor Yellow

    # Ensure the registry path exists
    if (-not (Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
    }

    # Set the maximum log file size
    Set-ItemProperty -Path $RegistryPath -Name "MaxSize" -Value $RequiredSizeKB -Type DWord

    # Verify the setting was applied
    $CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize" -ErrorAction SilentlyContinue

    if ($CurrentSize.MaxSize -ge $RequiredSizeKB) {
        Write-Host "✓ System Event Log size successfully set to $($CurrentSize.MaxSize) KB" -ForegroundColor Green
        Write-Host "✓ STIG WN11-AU-000510 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to set System Event Log size" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring System Event Log: $($_.Exception.Message)" -ForegroundColor Red
}
```

**How it works:**

**🎯 The Big Picture:**
System event logs capture critical information about the operating system's core functions — including hardware issues, driver behavior, and service events. While not as security-focused as Security logs, they are vital for **diagnostics and stability analysis**.

</details>

### Configuration Settings

#### WN11-CC-000005
<details>
<summary><strong>Prevent Lock Screen Camera Access</strong></summary>

**Problem:** Camera access from the lock screen must be disabled to prevent unauthorized use.

**Solution:** This script disables camera access from the Windows lock screen.

```powershell
<#
.SYNOPSIS
    Prevents camera access from lock screen to meet STIG WN11-CC-000005 requirements.
.DESCRIPTION
    Disables the ability to access the camera from the Windows lock screen.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000005
#>

# Registry path for personalization policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"

try {
    Write-Host "Disabling camera access from lock screen..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Prevent enabling lock screen camera
    Set-ItemProperty -Path $RegistryPath -Name "NoLockScreenCamera" -Value 1 -Type DWord
    
    # Also disable camera access via privacy settings
    $PrivacyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy"
    if (!(Test-Path $PrivacyPath)) {
        New-Item -Path $PrivacyPath -Force | Out-Null
        Write-Host "Created privacy registry path: $PrivacyPath" -ForegroundColor Cyan
    }
    
    # Disable camera access for apps above lock screen
    Set-ItemProperty -Path $PrivacyPath -Name "LetAppsAccessCamera_UserInControlOfTheseApps" -Value "Force Deny" -Type String
    
    # Verify the settings were applied
    $CameraSetting = Get-ItemProperty -Path $RegistryPath -Name "NoLockScreenCamera" -ErrorAction SilentlyContinue
    
    if ($CameraSetting.NoLockScreenCamera -eq 1) {
        Write-Host "✓ Lock screen camera access successfully disabled" -ForegroundColor Green
        Write-Host "✓ Camera cannot be accessed from lock screen" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000005 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable lock screen camera access" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring camera access settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Camera access from lock screen has been disabled for security." -ForegroundColor Green
```

**How it works:**
- `NoLockScreenCamera = 1`: Prevents camera access from lock screen
- `LetAppsAccessCamera_UserInControlOfTheseApps = "Force Deny"`: Blocks app camera access above lock
- Ensures unauthorized users cannot access camera when system is locked
- Prevents potential privacy violations and unauthorized recording
- Camera remains available after proper authentication

</details>

#### WN11-CC-000180
<details>
<summary><strong>Disable Autoplay for Non-Volume Devices</strong></summary>

**Problem:** Autoplay for non-volume devices (like MTP devices) must be disabled to prevent malicious code execution.

**Solution:** This script disables autoplay for non-volume devices through Group Policy registry settings.

```powershell
<#
.SYNOPSIS
    Disables autoplay for non-volume devices to meet STIG WN11-CC-000180 requirements.
.DESCRIPTION
    Prevents autoplay for non-volume devices (Media Transfer Protocol devices) to prevent malicious code execution.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000180
#>

# Registry path for AutoPlay policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer"

try {
    Write-Host "Disabling autoplay for non-volume devices..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable autoplay for non-volume devices
    Set-ItemProperty -Path $RegistryPath -Name "NoAutoplayfornonVolume" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "NoAutoplayfornonVolume" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.NoAutoplayfornonVolume -eq 1) {
        Write-Host "✓ Autoplay for non-volume devices successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000180 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable autoplay for non-volume devices" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring autoplay settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Note: A system restart may be required for changes to take full effect." -ForegroundColor Yellow
```

**How it works:**

**🎯 The Big Picture:** Autoplay is a Windows feature that automatically runs programs when you insert media (like USB drives, CDs, etc.). While convenient, this creates a major security risk - malicious USB drives can automatically execute malware when plugged in. Non-volume devices (like smartphones, cameras, MTP devices) are particularly risky because they can contain executable files disguised as media.

</details>

#### WN11-CC-000185
<details>
<summary><strong>Prevent Autorun Commands</strong></summary>

**Problem:** The default autorun behavior must be configured to prevent autorun commands from executing.

**Solution:** This script configures the system to not execute any autorun commands.

```powershell
<#
.SYNOPSIS
    Prevents autorun commands from executing to meet STIG WN11-CC-000185 requirements.
.DESCRIPTION
    Configures the default autorun behavior to prevent autorun commands from executing automatically.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
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
```

**How it works:**

**🎯 The Big Picture:** Autorun is an older Windows feature that automatically executes commands specified in "autorun.inf" files when removable media is inserted. This is extremely dangerous because any USB drive, CD, or network drive can contain an autorun.inf file that runs malicious commands immediately when connected. This script completely disables autorun command execution.

</details>

#### WN11-CC-000190
<details>
<summary><strong>Disable Autoplay for All Drives</strong></summary>

**Problem:** Autoplay must be disabled for all drives to prevent malicious code execution.

**Solution:** This script disables autoplay functionality for all drives system-wide.

```powershell
<#
.SYNOPSIS
    Disables autoplay for all drives to meet STIG WN11-CC-000190 requirements.
.DESCRIPTION
    Turns off AutoPlay for all drives by setting the NoDriveTypeAutoRun value to 255 (0xFF).
    This prevents malicious code from executing automatically from any drive type.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-31
    Version         : 1.1
    STIG-ID         : WN11-CC-000190
#>

# Define the required registry path and value name from the STIG
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$ValueName = "NoDriveTypeAutoRun"
$RequiredValue = 255 # 0xFF disables AutoPlay on unknown, removable, CD-ROM, network, and RAM drives

try {
    Write-Host "Disabling AutoPlay for all drives to meet STIG WN11-CC-000190..." -ForegroundColor Yellow

    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }

    # Set the required registry value to disable AutoPlay
    Set-ItemProperty -Path $RegistryPath -Name $ValueName -Value $RequiredValue -Type DWord -Force
    
    # --- Verification ---
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name $ValueName -ErrorAction SilentlyContinue

    if ($CurrentSetting.$ValueName -eq $RequiredValue) {
        Write-Host "--------------------------------------------------------" -ForegroundColor DarkGray
        Write-Host "✓ SUCCESS: AutoPlay successfully disabled for all drives." -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000190 requirement satisfied." -ForegroundColor Green
    } else {
        Write-Host "--------------------------------------------------------" -ForegroundColor DarkGray
        Write-Host "✗ FAILURE: Failed to verify the registry setting." -ForegroundColor Red
        Write-Host "  Please check permissions for path: $RegistryPath" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ FATAL ERROR: An exception occurred. $($_.Exception.Message)" -ForegroundColor Red
}
```

**How it works:**

**🎯 The Big Picture:** The script targets a single, powerful registry key to achieve system-wide security.

* **`NoDriveTypeAutoRun = 255`**: By setting this `REG_DWORD` value in the Explorer policies, the script uses the hexadecimal value `0xFF`. This is a bitmask that instructs Windows to **disable AutoPlay on all drive types** without exception, including removable media, network drives, and CD-ROMs.
* **Prevents Malicious Execution**: This ensures that no code can run automatically when a drive is connected, mitigating a common attack vector for malware.
</details>

#### WN11-CC-000197
<details>
<summary><strong>Turn Off Microsoft Consumer Experiences</strong></summary>

**Problem:** Microsoft consumer experiences must be turned off to prevent unwanted app suggestions and installations.

**Solution:** This script disables Microsoft consumer experiences that may suggest or install unwanted applications.

```powershell
<#
.SYNOPSIS
    Turns off Microsoft consumer experiences to meet STIG WN11-CC-000197 requirements.
.DESCRIPTION
    Disables Microsoft consumer experiences that suggest third-party content and apps.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000197
#>

# Registry path for Cloud Content policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent"

try {
    Write-Host "Turning off Microsoft consumer experiences..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable Windows Consumer Features
    Set-ItemProperty -Path $RegistryPath -Name "DisableWindowsConsumerFeatures" -Value 1 -Type DWord
    
    # Also disable third-party suggestions
    Set-ItemProperty -Path $RegistryPath -Name "DisableThirdPartySuggestions" -Value 1 -Type DWord
    
    # Disable consumer account state content
    Set-ItemProperty -Path $RegistryPath -Name "DisableConsumerAccountStateContent" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $Setting1 = Get-ItemProperty -Path $RegistryPath -Name "DisableWindowsConsumerFeatures" -ErrorAction SilentlyContinue
    $Setting2 = Get-ItemProperty -Path $RegistryPath -Name "DisableThirdPartySuggestions" -ErrorAction SilentlyContinue
    
    if ($Setting1.DisableWindowsConsumerFeatures -eq 1 -and $Setting2.DisableThirdPartySuggestions -eq 1) {
        Write-Host "✓ Microsoft consumer experiences successfully disabled" -ForegroundColor Green
        Write-Host "✓ Third-party suggestions disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000197 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable consumer experiences" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring consumer experience settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "System will no longer suggest third-party apps or content." -ForegroundColor Green
```

**How it works:**

**🎯 The Big Picture:** In a professional or secure environment, features that suggest third-party apps or display ads are considered a distraction and a potential security risk. This script systematically disables these features.

* It targets the **`CloudContent`** policy path in the registry.
* It sets multiple values to `1` (**Enabled**), including:
    * **`DisableWindowsConsumerFeatures`**: The primary switch to turn off consumer-focused content.
    * **`DisableThirdPartySuggestions`**: Specifically blocks suggestions for non-Microsoft applications.
* This creates a cleaner, more controlled user experience free from unwanted promotions, which is essential for maintaining compliance and security.


</details>

#### WN11-CC-000210
<details>
<summary><strong>Enable Windows Defender SmartScreen</strong></summary>

**Problem:** Microsoft Defender SmartScreen for Explorer must be enabled to protect against malicious programs.

**Solution:** This script enables and configures Windows Defender SmartScreen with "Warn and prevent bypass" setting.

```powershell
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
```

**How it works:**
The script enforces the two specific registry settings required for STIG compliance, working together to protect users.

* **`EnableSmartScreen = 1`**: This `REG_DWORD` value acts as the master switch, turning the SmartScreen service **on** for File Explorer.
* **`ShellSmartScreenLevel = "Block"`**: This `REG_SZ` (String) value configures the behavior of SmartScreen. Setting it to **`Block`** corresponds to the "Warn and prevent bypass" option, which stops users from ignoring the warning and running a potentially dangerous file.
* Together, these settings ensure that any file downloaded or transferred to the machine is checked against Microsoft's reputation service before it can be executed.
</details>

#### WN11-CC-000270
<details>
<summary><strong>Prevent Saving Passwords in RDP</strong></summary>

**Problem:** Remote Desktop must be prevented from saving passwords for security.

**Solution:** This script disables password saving in Remote Desktop connections.

```powershell
<#
.SYNOPSIS
    Prevents saving passwords in RDP to meet STIG WN11-CC-000270 requirements.
.DESCRIPTION
    Disables the ability to save passwords in Remote Desktop Connection.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-CC-000270
#>

# Registry path for Terminal Services policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

try {
    Write-Host "Disabling password saving in Remote Desktop..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable password saving
    Set-ItemProperty -Path $RegistryPath -Name "DisablePasswordSaving" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "DisablePasswordSaving" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.DisablePasswordSaving -eq 1) {
        Write-Host "✓ RDP password saving successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000270 requirement satisfied" -ForegroundColor Green
        Write-Host "✓ Users cannot save credentials in RDP client" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable RDP password saving" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring RDP settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Users must enter credentials for each RDP session." -ForegroundColor Yellow
```

**How it works:**
- `DisablePasswordSaving = 1`: Prevents RDP client from saving passwords
- Users must type password every time they connect
- Prevents unauthorized access if device is compromised
- Protects against credential theft from saved RDP files

</details>

#### WN11-CC-000280
<details>
<summary><strong>Always Prompt for RDP Password</strong></summary>

**Problem:** Remote Desktop must always prompt for passwords on the remote system.

**Solution:** This script ensures RDP always requires password entry at connection.

```powershell
<#
.SYNOPSIS
    Configures RDP to always prompt for password to meet STIG WN11-CC-000280 requirements.
.DESCRIPTION
    Forces Remote Desktop to always request credentials upon connection.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-CC-000280
#>

# Registry path for Terminal Services policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\Terminal Services"

try {
    Write-Host "Configuring RDP to always prompt for password..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Force password prompt
    Set-ItemProperty -Path $RegistryPath -Name "fPromptForPassword" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "fPromptForPassword" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.fPromptForPassword -eq 1) {
        Write-Host "✓ RDP will always prompt for password" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000280 requirement satisfied" -ForegroundColor Green
        Write-Host "✓ Enhanced security for remote connections" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to configure RDP password prompt" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring RDP settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: RDP connections will always require password entry." -ForegroundColor Yellow
```

**How it works:**
- `fPromptForPassword = 1`: Forces password prompt on every connection
- Even if credentials are saved, still requires password
- Adds extra security layer for remote access
- Prevents automatic authentication bypass

</details>

#### WN11-CC-000295
<details>
<summary><strong>Prevent RSS Feed Attachments</strong></summary>

**Problem:** Attachments must be prevented from being downloaded from RSS feeds for security.

**Solution:** This script prevents RSS feed attachments from being downloaded automatically.

```powershell
<#
.SYNOPSIS
    Prevents RSS feed attachments from being downloaded to meet STIG WN11-CC-000295 requirements.
.DESCRIPTION
    Configures RSS Feeds to prevent downloading of enclosures/attachments for security.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000295
#>

# Registry path for RSS Feeds policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Internet Explorer\Feeds"

try {
    Write-Host "Preventing RSS feed attachments from downloading..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Prevent downloading of RSS feed enclosures/attachments
    Set-ItemProperty -Path $RegistryPath -Name "DisableEnclosureDownload" -Value 1 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "DisableEnclosureDownload" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.DisableEnclosureDownload -eq 1) {
        Write-Host "✓ RSS feed attachments successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000295 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable RSS feed attachments" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring RSS feed settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "RSS feeds will no longer automatically download attachments." -ForegroundColor Green
```

**How it works:**
- `DisableEnclosureDownload = 1`: Prevents automatic downloading of RSS feed attachments
- RSS enclosures are files attached to RSS feed items (like podcasts, videos, documents)
- This setting prevents potentially malicious files from being downloaded automatically
- Users can still manually download attachments if needed, but auto-download is blocked

</details>

#### WN11-CC-000305
<details>
<summary><strong>Disable Encrypted File Indexing</strong></summary>

**Problem:** Indexing of encrypted files must be turned off to prevent sensitive data exposure.

**Solution:** This script disables the indexing of encrypted files to protect sensitive information.

```powershell
<#
.SYNOPSIS
    Disables indexing of encrypted files to meet STIG WN11-CC-000305 requirements.
.DESCRIPTION
    Turns off indexing of encrypted files to prevent potential exposure of sensitive data.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000305
#>

# Registry path for Search policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"

try {
    Write-Host "Disabling indexing of encrypted files..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable indexing of encrypted files
    # Value 0 = Do not allow indexing of encrypted files
    Set-ItemProperty -Path $RegistryPath -Name "AllowIndexingEncryptedStoresOrItems" -Value 0 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "AllowIndexingEncryptedStoresOrItems" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.AllowIndexingEncryptedStoresOrItems -eq 0) {
        Write-Host "✓ Indexing of encrypted files successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000305 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable indexing of encrypted files" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring search indexing settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Encrypted files will no longer be indexed by Windows Search." -ForegroundColor Green
```

**How it works:**
- `AllowIndexingEncryptedStoresOrItems = 0`: Disables indexing of encrypted files
- Windows Search normally indexes file contents to make them searchable
- Indexing encrypted files could potentially expose sensitive information
- This setting ensures encrypted files remain fully protected from indexing

</details>

#### WN11-CC-000310
<details>
<summary><strong>Prevent User Installation Control</strong></summary>

**Problem:** Users must be prevented from changing installation options to maintain security controls.

**Solution:** This script prevents users from controlling installation options.

```powershell
<#
.SYNOPSIS
    Prevents users from changing installation options to meet STIG WN11-CC-000310 requirements.
.DESCRIPTION
    Disables user control over installation options to maintain administrative control.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000310
#>

# Registry path for Windows Installer policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"

try {
    Write-Host "Preventing users from changing installation options..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable user control over installs
    # Value 0 = Do not allow user control over installs
    Set-ItemProperty -Path $RegistryPath -Name "EnableUserControl" -Value 0 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableUserControl" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.EnableUserControl -eq 0) {
        Write-Host "✓ User control over installations successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000310 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable user control over installations" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring installation control settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Users can no longer modify installation options." -ForegroundColor Green
```

**How it works:**
- `EnableUserControl = 0`: Prevents users from changing installation options
- This ensures only administrators can control how software is installed
- Prevents users from bypassing security features during installations
- Maintains consistent security policies across all software installations

</details>

#### WN11-CC-000315
<details>
<summary><strong>Disable Elevated Privileges Installation</strong></summary>

**Problem:** The Windows Installer feature 'Always install with elevated privileges' must be disabled.

**Solution:** This script disables the elevated privileges installation feature to prevent privilege escalation.

```powershell
<#
.SYNOPSIS
    Disables 'Always install with elevated privileges' to meet STIG WN11-CC-000315 requirements.
.DESCRIPTION
    Prevents Windows Installer from always using elevated privileges during installations.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000315
#>

# Registry paths for Windows Installer policies (both machine and user)
$MachinePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer"
$UserPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer"

try {
    Write-Host "Disabling 'Always install with elevated privileges'..." -ForegroundColor Yellow
    
    # Configure machine policy
    if (!(Test-Path $MachinePath)) {
        New-Item -Path $MachinePath -Force | Out-Null
        Write-Host "Created machine registry path: $MachinePath" -ForegroundColor Cyan
    }
    
    # Configure user policy
    if (!(Test-Path $UserPath)) {
        New-Item -Path $UserPath -Force | Out-Null
        Write-Host "Created user registry path: $UserPath" -ForegroundColor Cyan
    }
    
    # Disable elevated privileges for machine installations
    Set-ItemProperty -Path $MachinePath -Name "AlwaysInstallElevated" -Value 0 -Type DWord
    
    # Disable elevated privileges for user installations  
    Set-ItemProperty -Path $UserPath -Name "AlwaysInstallElevated" -Value 0 -Type DWord
    
    # Verify the settings were applied
    $MachineSetting = Get-ItemProperty -Path $MachinePath -Name "AlwaysInstallElevated" -ErrorAction SilentlyContinue
    $UserSetting = Get-ItemProperty -Path $UserPath -Name "AlwaysInstallElevated" -ErrorAction SilentlyContinue
    
    if ($MachineSetting.AlwaysInstallElevated -eq 0 -and $UserSetting.AlwaysInstallElevated -eq 0) {
        Write-Host "✓ 'Always install with elevated privileges' successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000315 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable elevated privileges installation" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring installer privilege settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Windows Installer will no longer automatically use elevated privileges." -ForegroundColor Green
```

**How it works:**
- `AlwaysInstallElevated = 0`: Disables automatic elevated privileges for installations
- Must be set in both HKLM (machine) and HKCU (user) registry hives
- Prevents malicious installers from gaining system privileges
- Standard users will need admin approval for privileged installations
- This is a critical security setting to prevent privilege escalation attacks

</details>

#### WN11-CC-000326
<details>
<summary><strong>Enable PowerShell Script Block Logging</strong></summary>

**Problem:** PowerShell script block logging must be enabled for security monitoring.

**Solution:** This script enables PowerShell script block logging to monitor PowerShell activity.

```powershell
<#
.SYNOPSIS
    Enables PowerShell script block logging to meet STIG WN11-CC-000326 requirements.
.DESCRIPTION
    Configures PowerShell to log detailed script block information for security monitoring.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000326
#>

# Registry path for PowerShell script block logging
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging"

try {
    Write-Host "Enabling PowerShell script block logging..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Enable script block logging
    Set-ItemProperty -Path $RegistryPath -Name "EnableScriptBlockLogging" -Value 1 -Type DWord
    
    # Enable logging of script block invocation start/stop events
    Set-ItemProperty -Path $RegistryPath -Name "EnableScriptBlockInvocationLogging" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $LoggingSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableScriptBlockLogging" -ErrorAction SilentlyContinue
    $InvocationSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableScriptBlockInvocationLogging" -ErrorAction SilentlyContinue
    
    if ($LoggingSetting.EnableScriptBlockLogging -eq 1) {
        Write-Host "✓ PowerShell script block logging successfully enabled" -ForegroundColor Green
        Write-Host "✓ Script block invocation logging enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000326 requirement satisfied" -ForegroundColor Green
        Write-Host "✓ PowerShell activities will be logged to Event ID 4104" -ForegroundColor Cyan
    } else {
        Write-Host "✗ Failed to enable PowerShell script block logging" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring PowerShell logging settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "PowerShell script execution will now be logged for security monitoring." -ForegroundColor Green
```

**How it works:**
- `EnableScriptBlockLogging = 1`: Enables logging of PowerShell script blocks
- `EnableScriptBlockInvocationLogging = 1`: Logs when script blocks start and stop
- Script block logging captures PowerShell commands and scripts as they execute
- Logs are written to Windows Event Log (Event ID 4104) for security analysis
- Essential for detecting malicious PowerShell activity and forensic investigations

</details>

#### WN11-CC-000327
<details>
<summary><strong>Enable PowerShell Transcription</strong></summary>

**Problem:** PowerShell Transcription must be enabled for detailed activity logging.

**Solution:** This script enables PowerShell transcription to create detailed logs of PowerShell sessions.

```powershell
<#
.SYNOPSIS
    Enables PowerShell transcription logging to meet STIG WN11-CC-000327 requirements.
.DESCRIPTION
    Configures PowerShell to create transcription logs of all PowerShell activity.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-CC-000327
#>

# Registry path for PowerShell transcription
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription"

# Secure transcript output directory
$TranscriptPath = "C:\PowerShellTranscripts"

try {
    Write-Host "Enabling PowerShell transcription logging..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Create transcript directory if it doesn't exist
    if (!(Test-Path $TranscriptPath)) {
        New-Item -Path $TranscriptPath -ItemType Directory -Force | Out-Null
        Write-Host "Created transcript directory: $TranscriptPath" -ForegroundColor Cyan
        
        # Set secure permissions on transcript directory (Administrators only)
        $Acl = Get-Acl $TranscriptPath
        $Acl.SetAccessRuleProtection($true, $false)  # Remove inheritance
        $AdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $SystemRule = New-Object System.Security.AccessControl.FileSystemAccessRule("SYSTEM", "FullControl", "ContainerInherit,ObjectInherit", "None", "Allow")
        $Acl.SetAccessRule($AdminRule)
        $Acl.SetAccessRule($SystemRule)
        Set-Acl -Path $TranscriptPath -AclObject $Acl
        Write-Host "Set secure permissions on transcript directory" -ForegroundColor Cyan
    }
    
    # Enable PowerShell transcription
    Set-ItemProperty -Path $RegistryPath -Name "EnableTranscripting" -Value 1 -Type DWord
    
    # Set transcript output directory
    Set-ItemProperty -Path $RegistryPath -Name "OutputDirectory" -Value $TranscriptPath -Type String
    
    # Enable invocation headers in transcripts
    Set-ItemProperty -Path $RegistryPath -Name "EnableInvocationHeader" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $TranscriptSetting = Get-ItemProperty -Path $RegistryPath -Name "EnableTranscripting" -ErrorAction SilentlyContinue
    $DirectorySetting = Get-ItemProperty -Path $RegistryPath -Name "OutputDirectory" -ErrorAction SilentlyContinue
    
    if ($TranscriptSetting.EnableTranscripting -eq 1 -and $DirectorySetting.OutputDirectory -eq $TranscriptPath) {
        Write-Host "✓ PowerShell transcription successfully enabled" -ForegroundColor Green
        Write-Host "✓ Transcript directory: $TranscriptPath" -ForegroundColor Green
        Write-Host "✓ Invocation headers enabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000327 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to enable PowerShell transcription" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring PowerShell transcription: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "PowerShell sessions will now be transcribed to: $TranscriptPath" -ForegroundColor Green
```

**How it works:**
- `EnableTranscripting = 1`: Enables PowerShell transcription logging
- `OutputDirectory`: Specifies where transcript files are stored
- `EnableInvocationHeader = 1`: Includes detailed headers in transcript files
- Creates a secure directory with restricted permissions for transcript storage
- Transcripts capture complete PowerShell sessions including input and output
- Provides detailed forensic trail of all PowerShell activity

</details>

#### WN11-CC-000330
<details>
<summary><strong>Disable WinRM Basic Authentication</strong></summary>

**Problem:** WinRM must not use Basic authentication which sends credentials in clear text.

**Solution:** This script disables Basic authentication for Windows Remote Management.

```powershell
<#
.SYNOPSIS
    Disables WinRM Basic authentication to meet STIG WN11-CC-000330 requirements.
.DESCRIPTION
    Prevents WinRM from using Basic authentication which transmits credentials insecurely.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-CC-000330
#>

# Registry path for WinRM client policies
$RegistryPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WinRM\Client"

try {
    Write-Host "Disabling WinRM Basic authentication..." -ForegroundColor Yellow
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Disable Basic authentication
    Set-ItemProperty -Path $RegistryPath -Name "AllowBasic" -Value 0 -Type DWord
    
    # Verify the setting was applied
    $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "AllowBasic" -ErrorAction SilentlyContinue
    
    if ($CurrentSetting.AllowBasic -eq 0) {
        Write-Host "✓ WinRM Basic authentication successfully disabled" -ForegroundColor Green
        Write-Host "✓ STIG WN11-CC-000330 requirement satisfied" -ForegroundColor Green
        Write-Host "✓ WinRM will use secure authentication methods only" -ForegroundColor Green
        
        # Check WinRM configuration
        Write-Host "`nVerifying WinRM client configuration..." -ForegroundColor Cyan
        try {
            $winrmConfig = winrm get winrm/config/client
            Write-Host $winrmConfig | Select-String "Basic"
        } catch {
            Write-Host "Note: WinRM service may not be running" -ForegroundColor Yellow
        }
    } else {
        Write-Host "✗ Failed to disable WinRM Basic authentication" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring WinRM settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: WinRM will only use Kerberos or NTLM authentication." -ForegroundColor Yellow
```

**How it works:**

**🎯 The Big Picture:**
Basic authentication in WinRM sends credentials in base64 encoding (essentially clear text) over the network. This is extremely dangerous and can lead to credential theft. This script forces WinRM to use only secure authentication methods like Kerberos or NTLM.

**📋 Security Impact:**
- Prevents passwords from being transmitted in clear text
- Forces use of encrypted authentication protocols
- Protects against network sniffing attacks
- Essential for secure remote management

</details>

### Security Options

#### WN11-SO-000005
<details>
<summary><strong>Disable Built-in Administrator Account</strong></summary>

**Problem:** The built-in Administrator account must be disabled to prevent unauthorized use.

**Solution:** This script disables the default Administrator account using Group Policy for STIG compliance.

```powershell
<#
.SYNOPSIS
    Disables built-in Administrator account to meet STIG WN11-SO-000005 requirements.
.DESCRIPTION
    Configures Group Policy to disable the default Administrator account to prevent unauthorized access.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-SO-000005
#>

try {
    Write-Host "Disabling built-in Administrator account via Group Policy..." -ForegroundColor Yellow
    
    # Configure Group Policy to disable Administrator account
    $GPPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    
    # Create registry path if it doesn't exist
    if (!(Test-Path $GPPath)) {
        New-Item -Path $GPPath -Force | Out-Null
        Write-Host "Created Group Policy registry path: $GPPath" -ForegroundColor Cyan
    }
    
    # Set Group Policy to disable Administrator account (0 = Disabled)
    Set-ItemProperty -Path $GPPath -Name "EnableAdminAccount" -Value 0 -Type DWord
    
    # Verify the Group Policy setting was applied
    $GPSetting = Get-ItemProperty -Path $GPPath -Name "EnableAdminAccount" -ErrorAction SilentlyContinue
    
    if ($GPSetting.EnableAdminAccount -eq 0) {
        Write-Host "✓ Administrator account disabled via Group Policy" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000005 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to configure Group Policy for Administrator account" -ForegroundColor Red
    }
    
    # Also check current account status for verification
    $adminAccount = Get-LocalUser | Where-Object {$_.SID -like "*-500"}
    if ($adminAccount) {
        Write-Host "`nCurrent Administrator account status:" -ForegroundColor Cyan
        Get-LocalUser | Where-Object {$_.SID -like "*-500"} | Select-Object Name, Enabled, LastLogon
    }
    
} catch {
    Write-Host "✗ Error configuring Administrator account policy: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Use named administrative accounts instead of built-in Administrator." -ForegroundColor Yellow
```

**How it works:**

**🎯 The Big Picture:**
The built-in Administrator account is a well-known target for attackers. It has a predictable SID (ends with -500) and often has more privileges than necessary. Disabling it through Group Policy forces the use of named administrative accounts that can be better monitored and controlled.

**📋 Security Benefits:**
- Eliminates a common attack vector
- Forces use of traceable admin accounts
- Prevents brute force attacks on default account
- Complies with principle of least privilege
- Uses Group Policy for persistent enforcement

**🔍 Understanding the Code:**
- `EnableAdminAccount = 0`: Group Policy setting to disable Administrator account
- Group Policy method ensures setting persists through system changes
- Still allows emergency recovery through Safe Mode if needed

</details>

#### WN11-SO-000025
<details>
<summary><strong>Rename Built-in Guest Account</strong></summary>

**Problem:** The built-in guest account must be renamed from its default name for security.

**Solution:** This script configures Group Policy to rename the built-in guest account to a non-obvious name.

```powershell
<#
.SYNOPSIS
    Renames the built-in guest account to meet STIG WN11-SO-000025 requirements.
.DESCRIPTION
    Configures Group Policy to rename the built-in guest account from "Guest" to a non-obvious name.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-SO-000025
#>

# New name for the guest account (change this to your preferred name)
$NewGuestName = "Visitor_Account"

try {
    Write-Host "Configuring Group Policy to rename built-in guest account..." -ForegroundColor Yellow
    
    # Configure Group Policy for guest account rename
    $GPPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System"
    
    # Create registry path if it doesn't exist
    if (!(Test-Path $GPPath)) {
        New-Item -Path $GPPath -Force | Out-Null
        Write-Host "Created Group Policy registry path: $GPPath" -ForegroundColor Cyan
    }
    
    # Get current guest account name for reference
    $GuestAccount = Get-WmiObject Win32_UserAccount | Where-Object {$_.SID -like "*-501"}
    $OriginalName = $GuestAccount.Name
    
    Write-Host "Current guest account name: $OriginalName" -ForegroundColor Cyan
    
    # Set Group Policy to rename guest account
    Set-ItemProperty -Path $GPPath -Name "NewGuestName" -Value $NewGuestName -Type String
    
    # Also rename the account directly for immediate effect
    $GuestAccount.Rename($NewGuestName)
    
    # Verify the Group Policy setting was applied
    $GPSetting = Get-ItemProperty -Path $GPPath -Name "NewGuestName" -ErrorAction SilentlyContinue
    $RenamedAccount = Get-WmiObject Win32_UserAccount | Where-Object {$_.SID -like "*-501"}
    
    if ($GPSetting.NewGuestName -eq $NewGuestName -and $RenamedAccount.Name -eq $NewGuestName) {
        Write-Host "✓ Guest account successfully renamed from '$OriginalName' to '$NewGuestName'" -ForegroundColor Green
        Write-Host "✓ Group Policy configured to enforce guest account name" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000025 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to rename guest account or configure Group Policy" -ForegroundColor Red
    }
    
} catch {
    Write-Host "✗ Error renaming guest account: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "Note: This operation requires administrative privileges" -ForegroundColor Yellow
}

Write-Host "Built-in guest account name has been changed for security." -ForegroundColor Green
```

**How it works:**
- Uses Group Policy to enforce guest account rename
- Identifies the guest account by its well-known SID ending in "-501"
- `$GuestAccount.Rename()`: Renames the account using WMI method for immediate effect
- `NewGuestName`: Group Policy setting ensures rename persists
- Verification checks ensure both immediate rename and policy configuration are successful
- Renaming the guest account makes it less obvious to potential attackers

</details>

#### WN11-SO-000030
<details>
<summary><strong>Enable Audit Policy Subcategories</strong></summary>

**Problem:** Audit policy using subcategories must be enabled for more precise auditing capabilities.

**Solution:** This script enables subcategory audit policy settings to override category settings.

```powershell
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
    $AuditResult = & auditpol.exe /get /category:* 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Audit policy is functioning correctly" -ForegroundColor Green
    }
    
} catch {
    Write-Host "✗ Error configuring audit policy settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Audit policy subcategories are now enabled for precise auditing control." -ForegroundColor Green
```

**How it works:**
- `SCENoApplyLegacyAuditPolicy = 1`: Enables subcategory audit policy override
- This allows administrators to configure specific subcategories of auditing
- More granular control over what events are audited
- Subcategory settings take precedence over broader category settings
- Essential for detailed security monitoring and compliance

</details>

#### WN11-SO-000095
<details>
<summary><strong>Configure Smart Card Removal Behavior</strong></summary>

**Problem:** Smart Card removal option must be configured to Force Logoff or Lock Workstation.

**Solution:** This script configures the system to lock when a smart card is removed.

```powershell
<#
.SYNOPSIS
    Configures smart card removal behavior to meet STIG WN11-SO-000095 requirements.
.DESCRIPTION
    Sets the system to lock the workstation when a smart card is removed.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-SO-000095
#>

# Registry path for smart card policy (CORRECTED PATH)
$RegistryPath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"

try {
    Write-Host "Configuring smart card removal behavior..." -ForegroundColor Yellow
    
    # The Winlogon registry path should already exist on any Windows system
    if (Test-Path $RegistryPath) {
        # Configure smart card removal behavior
        # Value "1" = Lock Workstation, Value "2" = Force Logoff, Value "0" = No Action
        # Setting to "1" (Lock Workstation) for security while maintaining usability
        Set-ItemProperty -Path $RegistryPath -Name "SCRemoveOption" -Value "1" -Type String
        
        # Verify the setting was applied
        $CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "SCRemoveOption" -ErrorAction SilentlyContinue
        
        if ($CurrentSetting.SCRemoveOption -eq "1") {
            Write-Host "✓ Smart card removal behavior set to 'Lock Workstation'" -ForegroundColor Green
            Write-Host "✓ System will lock when smart card is removed" -ForegroundColor Green
            Write-Host "✓ STIG WN11-SO-000095 requirement satisfied" -ForegroundColor Green
        } elseif ($CurrentSetting.SCRemoveOption -eq "2") {
            Write-Host "✓ Smart card removal behavior set to 'Force Logoff'" -ForegroundColor Green
            Write-Host "✓ STIG WN11-SO-000095 requirement satisfied" -ForegroundColor Green
        } else {
            Write-Host "✗ Failed to configure smart card removal behavior" -ForegroundColor Red
        }
    } else {
        Write-Host "✗ Registry path '$RegistryPath' not found" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring smart card settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Smart card removal will now trigger workstation lock for security." -ForegroundColor Green
```

**How it works:**
- `SCRemoveOption = "1"`: Configures system to lock workstation when smart card is removed
- Value "1" = Lock Workstation (recommended for usability)
- Value "2" = Force Logoff (more secure but less user-friendly)
- **CORRECTED**: Uses proper registry path `\Windows NT\CurrentVersion\Winlogon\`
- Ensures unattended systems are automatically secured when smart card is removed
- Critical for environments using smart card authentication

</details>

#### WN11-SO-000230
<details>
<summary><strong>Use FIPS Compliant Algorithms</strong></summary>

**Problem:** The system must be configured to use FIPS-compliant algorithms for encryption, hashing, and signing.

**Solution:** This script enables FIPS-compliant cryptographic algorithms system-wide.

```powershell
<#
.SYNOPSIS
    Enables FIPS-compliant algorithms to meet STIG WN11-SO-000230 requirements.
.DESCRIPTION
    Configures the system to use only FIPS-compliant algorithms for all cryptographic operations.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-SO-000230
#>

# Registry path for FIPS policy
$RegistryPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa\FipsAlgorithmPolicy"

try {
    Write-Host "Enabling FIPS-compliant algorithms..." -ForegroundColor Yellow
    Write-Host "WARNING: This change requires a system restart to take effect!" -ForegroundColor Red
    
    # Create the registry path if it doesn't exist
    if (!(Test-Path $RegistryPath)) {
        New-Item -Path $RegistryPath -Force | Out-Null
        Write-Host "Created registry path: $RegistryPath" -ForegroundColor Cyan
    }
    
    # Enable FIPS-compliant algorithms
    # Value 1 = Use FIPS-compliant algorithms for encryption, hashing, and signing
    Set-ItemProperty -Path $RegistryPath -Name "Enabled" -Value 1 -Type DWord
    
    # Also set the policy registry value
    $PolicyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Lsa"
    Set-ItemProperty -Path $PolicyPath -Name "FipsAlgorithmPolicy" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $FIPSSetting = Get-ItemProperty -Path $RegistryPath -Name "Enabled" -ErrorAction SilentlyContinue
    $PolicySetting = Get-ItemProperty -Path $PolicyPath -Name "FipsAlgorithmPolicy" -ErrorAction SilentlyContinue
    
    if ($FIPSSetting.Enabled -eq 1 -and $PolicySetting.FipsAlgorithmPolicy -eq 1) {
        Write-Host "✓ FIPS-compliant algorithms successfully enabled" -ForegroundColor Green
        Write-Host "✓ System will use only FIPS-approved cryptographic algorithms" -ForegroundColor Green
        Write-Host "✓ STIG WN11-SO-000230 requirement satisfied" -ForegroundColor Green
        Write-Host "⚠️  RESTART REQUIRED: Changes take effect after system restart" -ForegroundColor Yellow
    } else {
        Write-Host "✗ Failed to enable FIPS-compliant algorithms" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error configuring FIPS settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "System configured to use FIPS-compliant cryptographic algorithms." -ForegroundColor Green
Write-Host "Please restart the system for changes to take effect." -ForegroundColor Yellow
```

**How it works:**
- `Enabled = 1`: Enables FIPS mode in the FIPS Algorithm Policy
- `FipsAlgorithmPolicy = 1`: Sets the LSA policy for FIPS compliance
- FIPS (Federal Information Processing Standards) ensures cryptographic security
- Only government-approved algorithms will be used for encryption, hashing, and signing
- **Important**: System restart required for FIPS mode to activate
- May break some applications that use non-FIPS algorithms

</details>

### User Configuration

#### WN11-UC-000015
<details>
<summary><strong>Turn Off Toast Notifications on Lock Screen</strong></summary>

**Problem:** Toast notifications to the lock screen must be turned off to prevent information disclosure.

**Solution:** This script disables toast notifications on the lock screen for the current user and system-wide.

```powershell
<#
.SYNOPSIS
    Turns off toast notifications on lock screen to meet STIG WN11-UC-000015 requirements.
.DESCRIPTION
    Disables toast notifications from appearing on the lock screen to protect sensitive information.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : linkedin.com/in/abdullah-al-rafi03/
    GitHub          : github.com/rafi03
    Date Created    : 2025-07-29
    Last Modified   : 2025-07-29
    Version         : 1.0
    STIG-ID         : WN11-UC-000015
#>

# Primary registry path (STIG specifies HKCU)
$UserPolicyPath = "HKCU:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"
# Secondary path for machine-wide enforcement
$MachinePolicyPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications"

try {
    Write-Host "Turning off toast notifications on lock screen..." -ForegroundColor Yellow
    
    # Configure for current user (STIG requirement)
    if (!(Test-Path $UserPolicyPath)) {
        New-Item -Path $UserPolicyPath -Force | Out-Null
        Write-Host "Created user policy registry path: $UserPolicyPath" -ForegroundColor Cyan
    }
    
    # Disable toast notifications on lock screen for current user
    Set-ItemProperty -Path $UserPolicyPath -Name "NoToastApplicationNotificationOnLockScreen" -Value 1 -Type DWord
    
    # Also configure machine-wide for comprehensive coverage
    if (!(Test-Path $MachinePolicyPath)) {
        New-Item -Path $MachinePolicyPath -Force | Out-Null
        Write-Host "Created machine policy registry path: $MachinePolicyPath" -ForegroundColor Cyan
    }
    
    Set-ItemProperty -Path $MachinePolicyPath -Name "NoToastApplicationNotificationOnLockScreen" -Value 1 -Type DWord
    
    # Verify the settings were applied
    $UserSetting = Get-ItemProperty -Path $UserPolicyPath -Name "NoToastApplicationNotificationOnLockScreen" -ErrorAction SilentlyContinue
    $MachineSetting = Get-ItemProperty -Path $MachinePolicyPath -Name "NoToastApplicationNotificationOnLockScreen" -ErrorAction SilentlyContinue
    
    if ($UserSetting.NoToastApplicationNotificationOnLockScreen -eq 1) {
        Write-Host "✓ Toast notifications on lock screen successfully disabled for current user" -ForegroundColor Green
        Write-Host "✓ STIG WN11-UC-000015 requirement satisfied" -ForegroundColor Green
    } else {
        Write-Host "✗ Failed to disable toast notifications for current user" -ForegroundColor Red
    }
    
    if ($MachineSetting.NoToastApplicationNotificationOnLockScreen -eq 1) {
        Write-Host "✓ Toast notifications on lock screen disabled machine-wide" -ForegroundColor Green
    }
    
} catch {
    Write-Host "✗ Error configuring notification settings: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Lock screen will no longer display toast notifications." -ForegroundColor Green
```

**How it works:**
- `NoToastApplicationNotificationOnLockScreen = 1`: Disables toast notifications on lock screen
- **CORRECTED**: Primary focus on `HKCU` (Current User) as specified by STIG
- Also configures machine-wide policy for comprehensive coverage
- **REMOVED**: Extra scope creep settings that aren't part of STIG requirement
- Prevents sensitive information from appearing on lock screen
- Unauthorized users cannot see notification contents when system is locked

</details>

---

## ⚠️ Prerequisites

- **Administrative Privileges**: All scripts must be run as Administrator
- **PowerShell Version**: PowerShell 5.1 or higher (comes with Windows 11)
- **Execution Policy**: Set to allow script execution:
  ```powershell
  Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine
  ```
- **Windows 11**: Scripts are designed specifically for Windows 11 systems
- **Backup**: Always create a system backup before running scripts:
  ```powershell
  .\backup-settings.ps1
  ```

## 🛠️ Advanced Usage

<details>
<summary><strong>Running Scripts with Parameters</strong></summary>

Some scripts accept parameters for customization:

```powershell
# Run with custom log file
.\STIG-ID-WN11-AU-000500.ps1 -LogFile "C:\Logs\STIG-Remediation.log"

# Run in test mode (shows what would change without making changes)
.\STIG-ID-WN11-AC-000005.ps1 -WhatIf

# Run with verbose output
.\STIG-ID-WN11-CC-000190.ps1 -Verbose
```

</details>

<details>
<summary><strong>Automation and Scheduling</strong></summary>

### Schedule Regular Compliance Checks

Create a scheduled task to run compliance checks:

```powershell
$Action = New-ScheduledTaskAction -Execute "PowerShell.exe" -Argument "-ExecutionPolicy Bypass -File C:\STIGScripts\compliance-check.ps1"
$Trigger = New-ScheduledTaskTrigger -Weekly -At 9am -DaysOfWeek Monday
$Principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

Register-ScheduledTask -TaskName "Weekly STIG Compliance Check" -Action $Action -Trigger $Trigger -Principal $Principal
```

### Remote Deployment

Deploy to multiple systems using PowerShell remoting:

```powershell
$Computers = @("Computer1", "Computer2", "Computer3")
$Computers | ForEach-Object {
    Invoke-Command -ComputerName $_ -FilePath ".\Run-All-STIG-Remediations.ps1" -Credential (Get-Credential)
}
```

</details>

## 🔍 Troubleshooting

<details>
<summary><strong>Common Issues and Solutions</strong></summary>

### Script Execution Errors

**Problem:** "cannot be loaded because running scripts is disabled"
```powershell
# Solution: Set execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

**Problem:** "Access is denied"
```powershell
# Solution: Run PowerShell as Administrator
# Right-click PowerShell → Run as Administrator
```

### Registry Access Issues

**Problem:** "Cannot find path 'HKLM:\...'"
```powershell
# Solution: Check if running as Administrator
# Some registry paths require elevation
```

### Verification Failures

**Problem:** Settings don't apply after script runs
```powershell
# Solution 1: Force Group Policy update
gpupdate /force

# Solution 2: Restart the computer
Restart-Computer

# Solution 3: Check for conflicting Group Policy
rsop.msc  # View resultant set of policy
```

</details>

## 📈 Compliance Reporting

<details>
<summary><strong>Generating Compliance Reports</strong></summary>

### HTML Compliance Report

Create a professional HTML report:

```powershell
# Run compliance check and export to HTML
.\compliance-check.ps1 | ConvertTo-Html -Title "STIG Compliance Report" -PreContent "<h1>Windows 11 STIG Compliance Status</h1>" | Out-File "Compliance-Report.html"

# Open in browser
Start-Process "Compliance-Report.html"
```

### CSV Export for Analysis

Export results for Excel analysis:

```powershell
# Export to CSV
.\compliance-check.ps1 | Export-Csv -Path "STIG-Compliance-Results.csv" -NoTypeInformation

# Open in Excel
Start-Process "STIG-Compliance-Results.csv"
```

### Integration with SCAP Tools

These scripts complement SCAP scanning tools:
- Run scripts to remediate findings
- Re-scan with SCAP to verify compliance
- Document remediation in your POA&M

</details>

## 🤝 Contributing

Contributions are welcome! Please follow these guidelines:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/new-stig-remediation
   ```
3. **Test your changes thoroughly**
   - Test on clean Windows 11 VM
   - Verify no negative system impact
   - Confirm STIG compliance
4. **Update documentation**
   - Add script to README
   - Update compliance matrix
   - Include in backup/restore scripts
5. **Submit a pull request**
   - Describe changes clearly
   - Reference STIG ID and requirements
   - Include test results

### Code Standards

- Follow PowerShell best practices
- Include comprehensive error handling
- Add detailed comments and help text
- Use consistent formatting
- Test on multiple Windows 11 builds

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## ⚠️ Disclaimer

These scripts modify system security settings. Always:
- Test in a non-production environment first
- Create backups before applying changes
- Understand each change before implementing
- Verify changes meet your organization's security requirements

The authors are not responsible for any system issues that may arise from using these scripts.

## 📞 Support

For questions or issues:

- **GitHub Issues**: [Create an issue](https://github.com/yourusername/windows11-stig-compliance/issues)
- **LinkedIn**: [Abdullah Al Rafi](https://linkedin.com/in/abdullah-al-rafi03/)
- **Email**: your.email@example.com

## 🙏 Acknowledgments

- DISA for STIG development and documentation
- Tenable for vulnerability scanning capabilities
- PowerShell community for scripting best practices
- Security professionals who contributed feedback

---

*Last updated: July 30, 2025*
*Version: 2.0 - Added 20 additional STIG remediations for total of 40 compliance fixes*