# Azure Resource Group and Resource Deployment Script  
  
This script automates the creation of an Azure Resource Group and the deployment of resources and indexes needed to run the Denial Navigator Power App solution. 
  
## Prerequisites  
  
- PowerShell  
- Azure CLI  
- Owner or Contributor permissions in an Azure subscription
  
## Script Overview  
  
The script performs the following steps:  
  
1. Sets the execution policy to bypass.  
2. Initializes necessary variables.  
3. Logs into Azure with the specified tenant.  
4. Creates a new Azure Resource Group.  
5. Deploys resources using a Bicep file.  
6. Sets up indexes for the deployed Azure Search Service.  

When the script is run successfully you will see the following resources in a new Resource Group.
-	Storage Account
-	Deployment Script
-	Azure Open AI Model
-	Search Service

In addition to the resources created, the storage account and search service will have additional items created.
Storage Account
-	A storage container labeled ‘parse’
-	A storage container labeled ‘recs’
-	An index labeled ‘filerecs-autocreate’
-	An index labeled 'parse-autocreate’
-	An indexer labeled 'indexerparse-autocreate’
-	An indexer labeled 'indexerrec-auotcreate’
-	A data source connected to the ‘parse’ container
-	A data source connected to the ‘recs’ container

### Variables  
  
- `newRG`: Name of the new resource group.  
- `loc`: The location where resources will be created.  
- `bicepFile`: Filepath to the Bicep template file.  
- `tenant`: Azure tenant ID. 
- `sub` : Subscription ID. 
  
  
## Usage  
  
1. Clone this repository or download the script file.  
2. Open a PowerShell ISE.  
3. Navigate to the directory containing the script.  
4. Change variables 
    > newRG -The name of your new resource group. You are limited to letters, numbers and dashes. 
    > loc - The location where the resources will be 
    > tenant: The ID of the Azure tenant that you want the resources created. To find the tenant id in the portal or via Azure CLI can be [found here](https://learn.microsoft.com/en-us/azure/azure-portal/get-subscription-tenant-id)
    > sub: The id of the subscription you want to add the resources to. 
 
5. Run the script with the following command:  
  
    ```powershell  
    .\AddResource.ps1  
    ```  
  
## Disclaimer

**THIS CODE IS PROVIDED *AS IS* WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESS OR IMPLIED, INCLUDING ANY IMPLIED WARRANTIES OF FITNESS FOR A PARTICULAR PURPOSE, MERCHANTABILITY, OR NON-INFRINGEMENT.** 