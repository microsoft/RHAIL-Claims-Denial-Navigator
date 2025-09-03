<#
.SYNOPSIS
    This script automates the creation of Azure resources using a Bicep template.

.DESCRIPTION
    The script performs the following tasks:
    1. Sets the execution policy to bypass for the current process.
    2. Defines variables for the resource group, location, Bicep file, tenant ID, and subscription ID.
    3. Installs Azure CLI if not already installed.
    4. Logs into Azure using the specified tenant ID.
    5. Sets the specified subscription as the default.
    6. Creates a new resource group in the specified location.
    7. Deploys resources using the Bicep template.
    8. Retrieves outputs from the deployment to create indexes.
    9. Executes a script to set up the search service.
    10. Measures and outputs the script execution time.

.PARAMETER newRG
    Name of the new resource group. All resources will be created here.

.PARAMETER loc
    The location where the resources will be created. Select the region closest to you.

.PARAMETER bicepFile
    Filepath to the Bicep file.

.PARAMETER tenant
    Tenant ID for Azure login.

.PARAMETER sub
    Subscription ID for Azure.

.EXAMPLE
    .\AddResource.ps1

.NOTES
    Author: RHAIL Dev team
    Date: 2025-03-06

	
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
#>





Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass

New-Variable -Name newRG -Value "ClaimCopilot-RG" -Description "Name of the new resource group. All resources will be here" -Force
New-Variable -name loc -Value "East US 2" -Description "The location you want your resources created in. Select region closest to you" -Force
New-Variable -name bicepFile -Value .\main.bicep -Description "Filepath to the bicep file" -Force
New-Variable -name tenant -Value "<YOUR-TENANT-ID>" -Force
New-Variable -Name sub -Value "<YOUR-SUBSCRIPTION-ID>" -Description "ID of the Azure Sponsorship Sub"
$timestamp = Get-Date -Format "yyyy-MM-dd-HH-mm-ss"
Write-Output "[$timestamp] Start creation"


#check if successfully installed
az login --tenant $tenant
#add sub
az account set --subscription $sub
#create new resource group
az group create --name $newRG --location $loc
#deploy the resources
try{
    az deployment group create --resource-group $newRG --template-file $bicepFile --name DeployResources_$timestamp --only-show-errors
    Write-Host "Resources created !" -ForegroundColor Green
    #get outputs from deployment to create indexes
    $searchServiceName = az deployment group show -g $newRG -n DeployResources_$timestamp --query properties.outputs.searchServicesName.value
    $connString = az deployment group show -g $newRG -n DeployResources_$timestamp --query properties.outputs.dataSourceConnectionString.value
    $storageAccount =  az deployment group show -g $newRG -n DeployResources_$timestamp --query properties.outputs.storageAccountName.value
    $containerRec = az deployment group show -g $newRG -n DeployResources_$timestamp --query properties.outputs.containerNameRec.value
    $containerParse = az deployment group show -g $newRG -n DeployResources_$timestamp --query properties.outputs.containerNameParse.value

    .\IndexResource\SetupSearchService_v1.ps1 -searchServiceName $searchServiceName -dataSourceConnectionString $connString -storageAccountName $storageAccount -containerNameRec $containerRec -containerNameParse $containerParse -rgName $newRG

    Write-Host "Indexes created! Script complete" -BackgroundColor Green
}
catch{

      Write-Error $_.ErrorDetails.Message
        throw
}
