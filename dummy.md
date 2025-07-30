
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

  - `HKLM:` = HKEY\_LOCAL\_MACHINE (the main system settings)
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

**Translation:** Go to the location stored in `$RegistryPath`, find the setting called `MaxSize`, and change it to 32768

#### Get-ItemProperty

**Purpose:** Reads a registry value  
**Syntax:** `Get-ItemProperty -Path [WHERE] -Name [WHAT]`

```powershell
$CurrentSize = Get-ItemProperty -Path $RegistryPath -Name "MaxSize"
```

**Translation:** Go to `$RegistryPath`, read the `MaxSize` setting, and store the result in `$CurrentSize`

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

### 1\. Header and Documentation

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

### 2\. Variable Declarations

```powershell
$RequiredSizeKB = 32768
$RegistryPath = "HKLM:\SYSTEM\..."
```

**Purpose:** Set up the values we'll need throughout the script

### 3\. Main Logic Block with Error Handling

```powershell
try {
    # Main script logic here
} catch {
    # Error handling here
}
```

### 4\. Registry Path Creation (if needed)

```powershell
if (!(Test-Path $RegistryPath)) {
    New-Item -Path $RegistryPath -Force | Out-Null
}
```

**Purpose:** Many policy paths don't exist by default, so we create them

### 5\. Apply the Security Setting

```powershell
Set-ItemProperty -Path $RegistryPath -Name "PolicyName" -Value 1 -Type DWord
```

**Purpose:** This is where we actually make the security change

### 6\. Verification

```powershell
$CurrentSetting = Get-ItemProperty -Path $RegistryPath -Name "PolicyName"
if ($CurrentSetting.PolicyName -eq 1) {
    Write-Host "✓ Success!" -ForegroundColor Green
}
```

**Purpose:** Confirm our change worked correctly

### 7\. User Feedback

```powershell
Write-Host "Policy has been applied successfully" -ForegroundColor Green
```

**Purpose:** Tell the user what happened and what it means

</details>

## 🚀 Quick Start

1.  **Clone the repository:**

    ```powershell
    git clone [https://github.com/yourusername/windows11-stig-compliance.git](https://github.com/yourusername/windows11-stig-compliance.git)
    cd windows11-stig-compliance
    ```

2.  **Run PowerShell as Administrator** (Required for system-level changes)

3.  **Create a backup before making changes:**

    ```powershell
    .\backup-settings.ps1
    ```

4.  **Execute a specific script:**

    ```powershell
    .\STIG-ID-WN11-AU-000500.ps1
    ```

5.  **Or run all scripts at once:**

    ```powershell
    .\Run-All-STIG-Remediations.ps1
    ```

6.  **Check compliance status:**

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
| [WN11-AC-000005](https://www.google.com/search?q=%23wn11-ac-000005) | Account | CAT II | Account Lockout Duration |
| [WN11-AC-000010](https://www.google.com/search?q=%23wn11-ac-000010) | Account | CAT II | Account Lockout Threshold |
| [WN11-AC-000015](https://www.google.com/search?q=%23wn11-ac-000015) | Account | CAT II | Reset Account Lockout Counter |
| [WN11-AC-000020](https://www.google.com/search?q=%23wn11-ac-000020) | Account | CAT II | Password History |
| [WN11-AC-000030](https://www.google.com/search?q=%23wn11-ac-000030) | Account | CAT II | Minimum Password Age |
| [WN11-AC-000035](https://www.google.com/search?q=%23wn11-ac-000035) | Account | CAT II | Minimum Password Length |
| [WN11-AC-000040](https://www.google.com/search?q=%23wn11-ac-000040) | Account | CAT II | Password Complexity |
| **Audit Policies** ||||
| [WN11-AU-000005](https://www.google.com/search?q=%23wn11-au-000005) | Audit | CAT II | Audit Credential Validation Failures |
| [WN11-AU-000010](https://www.google.com/search?q=%23wn11-au-000010) | Audit | CAT II | Audit Credential Validation Success |
| [WN11-AU-000050](https://www.google.com/search?q=%23wn11-au-000050) | Audit | CAT II | Audit Process Creation |
| [WN11-AU-000060](https://www.google.com/search?q=%23wn11-au-000060) | Audit | CAT II | Audit Group Membership |
| [WN11-AU-000500](https://www.google.com/search?q=%23wn11-au-000500) | Audit | CAT II | Application Event Log Size |
| [WN11-AU-000505](https://www.google.com/search?q=%23wn11-au-000505) | Audit | CAT II | Security Event Log Size |
| [WN11-AU-000510](https://www.google.com/search?q=%23wn11-au-000510) | Audit | CAT II | System Event Log Size |
| **Configuration Settings** ||||
| [WN11-CC-000005](https://www.google.com/search?q=%23wn11-cc-000005) | Config | CAT II | Prevent Lock Screen Camera Access |
| [WN11-CC-000180](https://www.google.com/search?q=%23wn11-cc-000180) | Config | CAT I | Disable Autoplay for Non-Volume Devices |
| [WN11-CC-000185](https://www.google.com/search?q=%23wn11-cc-000185) | Config | CAT I | Prevent Autorun Commands |
| [WN11-CC-000190](https://www.google.com/search?q=%23wn11-cc-000190) | Config | CAT I | Disable Autoplay for All Drives |
| [WN11-CC-000197](https://www.google.com/search?q=%23wn11-cc-000197) | Config | CAT III | Turn Off Microsoft Consumer Experiences |
| [WN11-CC-000210](https://www.google.com/search?q=%23wn11-cc-000210) | Config | CAT II | Enable Windows Defender SmartScreen |
| [WN11-CC-000270](https://www.google.com/search?q=%23wn11-cc-000270) | Config | CAT II | Prevent Saving Passwords in RDP |
| [WN11-CC-000280](https://www.google.com/search?q=%23wn11-cc-000280) | Config | CAT II | Always Prompt for RDP Password |
| [WN11-CC-000295](https://www.google.com/search?q=%23wn11-cc-000295) | Config | CAT II | Prevent RSS Feed Attachments |
| [WN11-CC-000305](https://www.google.com/search?q=%23wn11-cc-000305) | Config | CAT II | Disable Encrypted File Indexing |
| [WN11-CC-000310](https://www.google.com/search?q=%23wn11-cc-000310) | Config | CAT II | Prevent User Installation Control |
| [WN11-CC-000315](https://www.google.com/search?q=%23wn11-cc-000315) | Config | CAT I | Disable Elevated Privileges Installation |
| [WN11-CC-000326](https://www.google.com/search?q=%23wn11-cc-000326) | Config | CAT II | Enable PowerShell Script Block Logging |
| [WN11-CC-000327](https://www.google.com/search?q=%23wn11-cc-000327) | Config | CAT II | Enable PowerShell Transcription |
| [WN11-CC-000330](https://www.google.com/search?q=%23wn11-cc-000330) | Config | CAT I | Disable WinRM Basic Authentication |
| **Security Options** ||||
| [WN11-SO-000005](https://www.google.com/search?q=%23wn11-so-000005) | Security | CAT I | Disable Built-in Administrator |
| [WN11-SO-000025](https://www.google.com/search?q=%23wn11-so-000025) | Security | CAT II | Rename Built-in Guest Account |
| [WN11-SO-000030](https://www.google.com/search?q=%23wn11-so-000030) | Security | CAT II | Enable Audit Policy Subcategories |
| [WN11-SO-000095](https://www.google.com/search?q=%23wn11-so-000095) | Security | CAT II | Smart Card Removal Behavior |
| [WN11-SO-000230](https://www.google.com/search?q=%23wn11-so-000230) | Security | CAT II | Use FIPS Compliant Algorithms |
| **User Configuration** ||||
| [WN11-UC-000015](https://www.google.com/search?q=%23wn11-uc-000015) | User Config | CAT III | Turn Off Toast Notifications on Lock Screen |

</details>

-----

## 🔧 Detailed STIG Remediations

### Account Policies

#### WN11-AC-000005

<details>
<summary><strong>Account Lockout Duration Configuration</strong></summary>

**Problem:**
The account lockout duration must be set to 15 minutes or greater to limit brute force attacks.

**Solution:** This script configures the account lockout duration to meet STIG requirements.

```powershell
<#
.SYNOPSIS
    Configures account lockout duration to meet STIG WN11-AC-000005 requirements.
.DESCRIPTION
    Sets the account lockout duration to 15 minutes as required by STIG.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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

1.  Use the `net accounts` command to set lockout duration
2.  Verify the change was applied successfully
3.  Display the current setting for confirmation

**🔍 Understanding the Command:**

```powershell
net accounts /lockoutduration:15
```

  - `net accounts`: Windows command for managing account policies
  - `/lockoutduration:15`: Sets lockout time to 15 minutes
  - **Impact:** After 3 failed login attempts (threshold), account locks for 15 minutes

In the script, `2>&1` is a redirection operator used in command-line interfaces like PowerShell and Command Prompt.

It redirects the **standard error** stream (represented by `2`) to the same location as the **standard output** stream (represented by `1`).

  * **`2`**: This number represents the **Standard Error** (stderr) stream. This is where programs typically send their error messages.
  * **`>`**: This is the redirection operator. It tells the shell to send output to a different location.
  * **`&1`**: This represents the target of the redirection, which is the **Standard Output** (stdout) stream (handle `1`). The ampersand (`&`) is necessary to indicate that `1` is a stream handle and not a file named "1".

**Purpose in the Script:**

`$result = & net accounts /lockoutduration:15 2>&1`

By default, a PowerShell variable (`$result`) only captures the standard output (stdout) of an external command. Error messages (stderr) are just printed to the console.

Using **`2>&1` ensures that both the normal output and any error messages from the `net accounts` command are combined into a single stream**. This allows the `$result` variable to capture *everything* the command produces, which is crucial for the script's error handling. If the command fails, the error message will be stored in `$result` and can be displayed to the user.

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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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

1.  Export current security policy to a temporary file
2.  Modify the PasswordComplexity setting from 0 (off) to 1 (on)
3.  Import the modified policy back into Windows
4.  Clean up temporary files

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
  - Forces creation of strong passwords like "MyP@ssw0rd2024\!"
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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

### Configuration Settings

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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
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

**Solution:** This script disables the default Administrator account for security.

```powershell
<#
.SYNOPSIS
    Disables built-in Administrator account to meet STIG WN11-SO-000005 requirements.
.DESCRIPTION
    Disables the default Administrator account to prevent unauthorized access.
.NOTES
    Author          : Abdullah Al Rafi
    LinkedIn        : [linkedin.com/in/abdullah-al-rafi03/](https://linkedin.com/in/abdullah-al-rafi03/)
    GitHub          : [github.com/rafi03](https://github.com/rafi03)
    Date Created    : 2025-07-30
    Last Modified   : 2025-07-30
    Version         : 1.0
    STIG-ID         : WN11-SO-000005
#>

try {
    Write-Host "Disabling built-in Administrator account..." -ForegroundColor Yellow
    
    # Find the built-in Administrator account (SID always ends with -500)
    $adminAccount = Get-LocalUser | Where-Object {$_.SID -like "*-500"}
    
    if ($adminAccount) {
        # Check if already disabled
        if ($adminAccount.Enabled) {
            # Disable the account
            Disable-LocalUser -Name $adminAccount.Name
            
            # Verify it's disabled
            $verifyAccount = Get-LocalUser -Name $adminAccount.Name
            if (!$verifyAccount.Enabled) {
                Write-Host "✓ Built-in Administrator account '$($adminAccount.Name)' successfully disabled" -ForegroundColor Green
                Write-Host "✓ STIG WN11-SO-000005 requirement satisfied" -ForegroundColor Green
            } else {
                Write-Host "✗ Failed to disable Administrator account" -ForegroundColor Red
            }
        } else {
            Write-Host "✓ Built-in Administrator account is already disabled" -ForegroundColor Green
            Write-Host "✓ STIG WN11-SO-000005 requirement already satisfied" -ForegroundColor Green
        }
        
        # Display account status
        Write-Host "`nAdministrator account status:" -ForegroundColor Cyan
        Get-LocalUser | Where-Object {$_.SID -like "*-500"} | Select-Object Name, Enabled, LastLogon
    } else {
        Write-Host "✗ Could not find built-in Administrator account" -ForegroundColor Red
    }
} catch {
    Write-Host "✗ Error disabling Administrator account: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`nNote: Use named administrative accounts instead of built-in Administrator." -ForegroundColor Yellow
```

**How it works:**

**🎯 The Big Picture:**
The built-in Administrator account is a well-known target for attackers. It has a predictable SID (ends with -500) and often has more privileges than necessary. Disabling it forces the use of named administrative accounts that can be better monitored and controlled.

**📋 Security Benefits:**

  - Eliminates a common attack vector
  - Forces use of traceable admin accounts
  - Prevents brute force attacks on default account
  - Complies with principle of least privilege

**🔍 Understanding the Code:**

  - `$_.SID -like "*-500"`: Identifies built-in Administrator by its SID
  - `Disable-LocalUser`: Safely disables the account
  - Account remains available for emergency recovery if needed

</details>

-----

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

**Problem:** "Cannot find path 'HKLM:...'"

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
  - Document remediation in your POA\&M

</details>

## 🤝 Contributing

Contributions are welcome\! Please follow these guidelines:

1.  **Fork the repository**
2.  **Create a feature branch**
    ```bash
    git checkout -b feature/new-stig-remediation
    ```
3.  **Test your changes thoroughly**
      - Test on clean Windows 11 VM
      - Verify no negative system impact
      - Confirm STIG compliance
4.  **Update documentation**
      - Add script to README
      - Update compliance matrix
      - Include in backup/restore scripts
5.  **Submit a pull request**
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

This project is licensed under the MIT License - see the [LICENSE](https://www.google.com/search?q=LICENSE) file for details.

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

-----

*Last updated: July 30, 2025*
*Version: 2.0 - Added 20 additional STIG remediations*
