@description('Azure region where resources should be deployed')
param location string = resourceGroup().location

//param rgName string = resourceGroup().name


@description('Desired name of the storage account')
param storageAccountName string = uniqueString(resourceGroup().id, deployment().name, 'blob')

@description('Name of the blob container')
param containerNameRec string = 'recs'

@description('Name of the blob container')
param containerNameParse string = 'parse'


@minLength(3)
@maxLength(24)
@description('Provide a name for the storage account. Use only lower case letters and numbers. The name must be unique across Azure.')
param searchServicesName string = 'Search${uniqueString(resourceGroup().id)}'

param accountAzureAIName string = 'ClaimsCopilot${uniqueString(resourceGroup().id)}'

@description('create storage account and blobs')
resource storage 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: storageAccountName
  location: location
  sku: {
    name: 'Standard_RAGRS'
  }
  kind: 'StorageV2'

  resource blobService 'blobServices' = {
    name: 'default'

    resource containerRecs 'containers' = {
      name: containerNameRec
    }

    resource containerParse 'containers' = {
      name: containerNameParse
    }
  }
}



resource searchServices 'Microsoft.Search/searchServices@2024-06-01-preview' = {
  name: searchServicesName
  location: location
  tags: {
    ProjectType: 'aoai-your-data-service'
  }
  sku: {
    name: 'basic'
  }
  properties: {
    replicaCount: 1
    partitionCount: 1
    hostingMode: 'default'
    publicNetworkAccess: 'Enabled'
    networkRuleSet: {
      ipRules: []
      bypass: 'None'
    }
    encryptionWithCmk: {
      enforcement: 'Unspecified'
    }
    disableLocalAuth: false
    authOptions: {
      apiKeyOnly: {}
    }
    disabledDataExfiltrationOptions: []
    semanticSearch: 'free'
  }
}


resource openAI 'Microsoft.CognitiveServices/accounts@2024-04-01-preview' = {
  name: accountAzureAIName
  location: location
  tags: {
    azopenai: 'rhaildev'
  }
  sku: {
    name: 'S0'
  }
  kind: 'OpenAI'
  properties: {
    customSubDomainName: accountAzureAIName
    publicNetworkAccess: 'Enabled'
  }
}


resource azureAIModel 'Microsoft.CognitiveServices/accounts/deployments@2024-04-01-preview' = {
  parent: openAI
  name: accountAzureAIName
  sku: {
    name: 'Standard'
    capacity: 90 //140
  }
  properties: {
    model: {
      format: 'OpenAI'
      name: 'gpt-4o'
      version: '2024-05-13'
    }
    versionUpgradeOption: 'OnceCurrentVersionExpired'
    currentCapacity: 140
    raiPolicyName: 'Microsoft.Default'
  }
}




output storageAccountName string = storageAccountName
output containerNameRec string = containerNameRec
output containerNameParse string = containerNameParse
output dataSourceConnectionString string = 'DefaultEndpointsProtocol=https;AccountName=${storageAccountName};AccountKey=${storage.listKeys().keys[0].value};'
output searchServicesName string = searchServicesName
