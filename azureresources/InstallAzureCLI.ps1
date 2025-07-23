<#
.SYNOPSIS
    This script checks for the presence of Azure CLI and installs it if not already installed.

.DESCRIPTION
    The script performs the following tasks:
    1. Checks if Azure CLI is installed on the system.
    2. If Azure CLI is not installed, it downloads and installs the Azure CLI.
    3. Removes the installer file after installation.

.EXAMPLE
    .\InstallAzureCLI.ps1

.NOTES
    Author: RHAIL Dev Team
    Date: 2025-03-06
#>


#install necessary modules
# Check if Azure CLI is installed
if (Get-Command az -ErrorAction SilentlyContinue) {
    Write-Output "Azure CLI is already installed."
} else {
    Write-Output "Azure CLI is not installed. Installing now..."
    # Download and install Azure CLI
    Invoke-WebRequest -Uri https://aka.ms/installazurecliwindows -OutFile .\AzureCLI.msi
    Start-Process msiexec.exe -ArgumentList '/I AzureCLI.msi /quiet' -Wait
    Remove-Item .\AzureCLI.msi
    Write-Output "Azure CLI installation completed."
}

