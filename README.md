# Active Directory User Account Automation Script

This PowerShell script automates the creation of user accounts in Active Directory (AD) using specified parameters. It includes input validation, error handling, duplicate checks, group membership assignment, and email notifications.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Screenshots](#screenshots)
- [Logging](#logging)
- [License](#license)

## Prerequisites

- macOS system
- VirtualBox installed
- Windows Server 2022 ISO file
- Active Directory Domain Services (AD DS) installed

## Installation

1. **Download VirtualBox**:
   - Install Oracle VM VirtualBox Base Packages for macOS.
   - ![Virtual Machine General Information](screenshots/VM_General_Information.png)
   *Virtual Machine General Information*

2. **Set Up Windows Server 2022**:
   - Download and configure the ISO file for Windows Server 2022 in VirtualBox.
   - Install Active Directory Domain Services (AD DS).
   - ![Confirmation Installation Selections](screenshots/Confirmation_Installation_Selections.png)
   *Confirmation of AD DS installation selections.*

3. **Enable Clipboard Sharing**:
   - Install Guest Additions to facilitate clipboard sharing between the host and the virtual machine.

## Usage

1. Open PowerShell ISE in your Windows Server virtual machine.
2. Copy the PowerShell script to your local directory.
3. Run the script with the required parameters:

```powershell
.\CreateUser.ps1 -UserName "jdoe" -Email "jdoe@testdomain.local" -Department "IT" -JobTitle "Developer"
