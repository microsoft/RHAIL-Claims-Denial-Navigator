<#
.SYNOPSIS
    This script adds indexers via API calls to complete the AI index setup process.

.DESCRIPTION
    The script performs the following tasks:
    1. Sets additional variables for API calls.
    2. Retrieves the API key for the search service.
    3. Creates the API headers and bodies.
    4. Creates JSON for indexes and updates them with the correct data source names.
    5. Defines data source definitions for the 'recs' and 'parse' containers.
    6. Creates the indexes, data sources, and indexers via API calls.

.PARAMETER searchServiceName
    The name of the AI search service created.

.PARAMETER dataSourceConnectionString
    The endpoint for blob storage.

.PARAMETER storageAccountName
    The name of the storage account.

.PARAMETER containerNameRec
    The name of the 'recs' container.

.PARAMETER containerNameParse
    The name of the 'parse' container.

.PARAMETER rgName
    The name of the resource group.

.EXAMPLE
    .\SetupSearchService.ps1 -searchServiceName "mySearchService" -dataSourceConnectionString "DefaultEndpointsProtocol=https;AccountName=myAccount;AccountKey=myKey;EndpointSuffix=core.windows.net" -storageAccountName "myStorageAccount" -containerNameRec "recs" -containerNameParse "parse" -rgName "myResourceGroup"

.NOTES
    Author: RHAIL Dev Team
    Date: 2025-03-06
#>

param( 
    [string] [Parameter(Mandatory=$true)] $searchServiceName , #the name of the AI search service we created 
    [string] [Parameter(Mandatory=$true)] [AllowEmptyString()] $dataSourceConnectionString , #the endpoint for blob storage
    [string] [Parameter(Mandatory=$true)] $storageAccountName,
    [string] [Parameter(Mandatory=$true)] $containerNameRec,
    [string] [Parameter(Mandatory=$true)] $containerNameParse,
    [string] [Parameter(Mandatory=$true)] $rgName
)


##### set additional variables for api calls 
$apiversion = '2024-07-01' 
$searchServiceName = $searchServiceName.Replace("`"","")
$storageAccountName = $storageAccountName.Replace("`"","")
$containerNameParse = $containerNameParse.Replace("`"","")
$containerNameRec = $containerNameRec.Replace("`"","")
$dataSourceConnectionString = $dataSourceConnectionString.Replace("`"","")
#$apiKey = Get-AzSearchAdminKeyPair -ResourceGroupName $rgName -ServiceName $searchServiceName | select Primary

$apiKey = az search admin-key show --resource-group $rgName --service-name $searchServiceName --query primaryKey
$apiKey =$apiKey.Replace("`"","")
#Write-Output $apiKey

##### create the api headers and bodies
$headers = @{ 'api-key' = "$apiKey"; 'Content-Type' = 'application/json'; }
$uri = "https://$searchServiceName.search.windows.net"

### create JSON for indexes 
$jsonRecsPath = '.\IndexResource\recsIndexProfile.json'
$jsonRecsContent = Get-Content -Path $jsonRecsPath 
$jsonRecsName = Get-Content -Path $jsonRecsPath | ConvertFrom-Json
$jsonRecsName = $jsonRecsName.name
$jsonParsePath = '.\IndexResource\parseIndexProfile.json'
$jsonParseContent = Get-Content -Path $jsonParsePath 
$jsonParseName = Get-Content -Path $jsonParsePath | ConvertFrom-Json
$jsonParseName = $jsonParseName.name

#edit json to have correct datasource name for indexer
$jsonRecIndexerPath = ".\IndexResource\indexerRec.json"
$jsonRecIndexerContent = Get-Content -Path $jsonRecIndexerPath -Raw | ConvertFrom-Json
$jsonRecIndexerContent.dataSourceName = "$($storageAccountName)recs"
$jsonRecIndexerName = $jsonRecIndexerContent.name
$jsonRecIndexerContent| ConvertTo-Json -Depth 32 | Set-Content -Path $jsonRecIndexerPath
$jsonRecIndexerContent = Get-Content -Path $jsonRecIndexerPath


$jsonParseIndexerPath = ".\IndexResource\indexerParse.json"
$jsonParseIndexerContent = Get-Content -Path $jsonParseIndexerPath -Raw | ConvertFrom-Json
$jsonParseIndexerContent.dataSourceName = "$($storageAccountName)parse"
$jsonParseIndexerName = $jsonParseIndexerContent.name
$jsonParseIndexerContent| ConvertTo-Json -Depth 32 | Set-Content -Path $jsonParseIndexerPath
$jsonParseIndexerContent = Get-Content -Path $jsonParseIndexerPath


#create datasource defs
######################################################################
$dataSourceDefinitionRec = @{
        'name' = "$($storageAccountName)recs";
        'type' = 'azureblob';
        'container' = @{
            'name' = $containerNameRec;
        };
        'credentials' = @{
            'connectionString' = $dataSourceConnectionString
        };
    }

$dataSourceDefinitionParse = @{
        'name' = "$($storageAccountName)parse";
        'type' = 'azureblob';
        'container' = @{
            'name' = $containerNameParse;
        };
        'credentials' = @{
            'connectionString' = $dataSourceConnectionString
        };
    }


try {
    # https://learn.microsoft.com/rest/api/searchservice/create-index
    ####create the 2 indexes 

    ##create parse index
    Invoke-WebRequest `
        -Method 'PUT' `
        -Uri "$uri/indexes/$($jsonParseName)?api-version=$apiversion" `
        -Headers $headers `
        -Body $jsonParseContent
    ##create recs index
    Invoke-WebRequest `
        -Method 'PUT' `
        -Uri "$uri/indexes/$($jsonRecsName)?api-version=$apiversion" `
        -Headers  $headers `
        -Body $jsonRecsContent

    # https://learn.microsoft.com/rest/api/searchservice/create-data-source
    Invoke-WebRequest `
            -Method 'PUT' `
            -Uri "$uri/datasources/$($dataSourceDefinitionParse['name'])?api-version=$apiversion" `
            -Headers $headers `
            -Body (ConvertTo-Json $dataSourceDefinitionParse)
        
    Invoke-WebRequest `
            -Method 'PUT' `
            -Uri "$uri/datasources/$($dataSourceDefinitionRec['name'])?api-version=$apiversion" `
            -Headers $headers `
            -Body (ConvertTo-Json $dataSourceDefinitionRec)

    # https://learn.microsoft.com/rest/api/searchservice/create-indexer
    Invoke-WebRequest `
            -Method 'PUT' `
            -Uri "$uri/indexers/$($jsonRecIndexerName)?api-version=$apiversion" `
            -Headers $headers `
            -Body $jsonRecIndexerContent

    Invoke-WebRequest `
            -Method 'PUT' `
            -Uri "$uri/indexers/$($jsonParseIndexerName)?api-version=$apiversion" `
            -Headers $headers `
            -Body $jsonParseIndexerContent
    }
 catch {
    Write-Error $_.ErrorDetails.Message
    throw
}

