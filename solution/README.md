# Claims Navigator Installation Guide

This guide provides a comprehensive overview of how to install the Claims Navigator Power Apps solution. Follow the steps below to set up the necessary resources and import the solution.

## Prerequisites

Before you begin, ensure you have the following:
- Azure Resources created with the script found in azureresources folder
- A SharePoint site made to the specifications found on the main README

## Downloading the Claims Navigator App
Download the zip file in this folder.

## Import the Claims Navigator App

1. In a web browser, navigate to [Power Apps](https://make.preview.powerapps.com/).

2. Sign in with credentials with Admin access.

3. In the menu on the left, select Solutions.

4. Click Import Solution and select the Power App package ClaimsNavigator.zip
![Claims Navigator Import](/assets/appuploadsolution.png)

5. Click next until you reach Connections. Update the connections as needed until all 5 connections have a green check mark next to them.
![Claims Navigator Connections](/assets/appconnections.png)

6. Fill out the Enviormental Variables and select Import and wait until the process is complete
![Claims Navigator Variables](/assets/appenvvariable.png)

## Configure the PowerApp

1. Navigate to the solution. On the left hand side menu select **Dashboards > Claim Navigator** for 835 File. 
    ![Claims Dashboard](/assets/appdash.png)

2. Select the IFrame:File Upload box and then click Edit Component.

    ![Claims IFrame](/assets/appiframe.png)

3. In the Edit Component dialogue, edit the URL to match your SharePoint document library URL. Close and Save.
    ![Claims IFrame2](/assets/appiframe2.png)

4. In the Solution view, select **Apps > Denial Navigator**.

5. Select publish and wait for the changes to be published. Once finished select Play and navigate to the file intake section, Your inline Sharepoint site will be updated. 


## Import Code Definitions

1. Download the file **rhail_codedefinitions.csv** from the **data** section of this repo.
2. Navigate to the table **Code Definitions** in the solution and select **Import** > **Import Data**.
3. Select the file from your computer.
![Import](/assets/uploadcodes_1.png)
4. Click through until you reach the destination settings. Confirm that it is uploading to the existing table `rhail_CodeDefinition`.
![Import](/assets/uploadcodes_2.png)
5. Confirm the mapping of columns is as shown below.
![Import](/assets/uploadcodes_3.png)
6. Submit and confirm that the data is loaded.

## Security Recommendations

### Objective
This section outlines key security practices for protecting Azure resources integrated with Microsoft Power Platform. It focuses on minimizing exposure to threats, securing sensitive services, and enabling monitoring for proactive threat detection.


To ensure a secure and resilient architecture when using services like Azure OpenAI and Azure Cognitive Search with Power Platform, follow these three core recommendations:

1. **Protect backend Azure resources** from public internet exposure using virtual networking and private endpoints.
2. **Implement content safety** mechanisms to guard against malicious inputs and model exploitation.
3. **Enable logging and diagnostics** to monitor activity and support threat investigations.


## Implementation Overview

### 1. Protect Backend Azure Resources
- **Objective**: Prevent direct exposure of Azure services to the public internet.
- **Actions**:
  - Secure Azure resources with a **Virtual Network (VNET)**.
  - Use **VNET subnet delegation** to connect Power Platform.
  - Expose Azure services to Power Platform via **Private Endpoints**.
- **Resources**:
  - [Microsoft Power Platform VNet Support Setup Guide](https://urldefense.com/v3/__https://learn.microsoft.com/en-us/power-platform/admin/vnet-support-setup-configure?tabs=new__;!!Jrgwm_wKFTPpVg!MmYxbo8T9xCsJA4qkZFClTNVk3jRvXvj1h8tjsJOhIdOvAvbsPneCyY9ZgQ3v_tjsW72JbHV4B3lTMPcU9iI7O8$)
  - [VNET Support Overview](https://urldefense.com/v3/__https://techcommunity.microsoft.com/blog/azurenetworkingblog/architecture-of-azure-vnet-support-for-power-platform/4304802__;!!Jrgwm_wKFTPpVg!MmYxbo8T9xCsJA4qkZFClTNVk3jRvXvj1h8tjsJOhIdOvAvbsPneCyY9ZgQ3v_tjsW72JbHV4B3lTMPc-ACMMjQ$)
  - [Secure Azure OpenAI with virtual networking](https://urldefense.com/v3/__https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/network__;!!Jrgwm_wKFTPpVg!MmYxbo8T9xCsJA4qkZFClTNVk3jRvXvj1h8tjsJOhIdOvAvbsPneCyY9ZgQ3v_tjsW72JbHV4B3lTMPcHCFsz3w$)
  - [Secure Cognitive Search with virtual networking](https://urldefense.com/v3/__https://learn.microsoft.com/en-us/azure/search/service-create-private-endpoint__;!!Jrgwm_wKFTPpVg!MmYxbo8T9xCsJA4qkZFClTNVk3jRvXvj1h8tjsJOhIdOvAvbsPneCyY9ZgQ3v_tjsW72JbHV4B3lTMPchq-CDnc$)
  - [Using private endpoint in Azure AI Foundry](https://urldefense.com/v3/__https://learn.microsoft.com/en-us/azure/ai-foundry/how-to/configure-private-link?tabs=azure-portal&pivots=fdp-project__;!!Jrgwm_wKFTPpVg!MmYxbo8T9xCsJA4qkZFClTNVk3jRvXvj1h8tjsJOhIdOvAvbsPneCyY9ZgQ3v_tjsW72JbHV4B3lTMPcS_L396s$)

### 2. Content Safety

- **Objective**: Safeguard AI solutions against risks such as content manipulation and model exploitation.
- **Actions**:
  - Use **Azure API Management** to securely manage and expose Azure OpenAI endpoints. .
  - Integrate **Azure Content Safety** o automatically detect and mitigate risks from potentially harmful or malicious user-uploaded documents.
- **Resources**:
  - [Integrating Azure Content Safety](https://urldefense.com/v3/__https://techcommunity.microsoft.com/blog/fasttrackforazureblog/integrating-azure-ai-content-safety-with-api-management-for-azure-openai-endpoin/4202505__;!!Jrgwm_wKFTPpVg!MmYxbo8T9xCsJA4qkZFClTNVk3jRvXvj1h8tjsJOhIdOvAvbsPneCyY9ZgQ3v_tjsW72JbHV4B3lTMPcC9o5jPU$)
  - [Using Azure API Management for Azure OpenAI](https://urldefense.com/v3/__https://learn.microsoft.com/en-us/shows/apis-in-action/leveraging-api-management-for-openai-applicationsuse-azure-api-management-apim-to-manage-secure-and-scale-your-llm-based-applications__;!!Jrgwm_wKFTPpVg!MmYxbo8T9xCsJA4qkZFClTNVk3jRvXvj1h8tjsJOhIdOvAvbsPneCyY9ZgQ3v_tjsW72JbHV4B3lTMPcasS8dR0$)

### 3. Enable Logging

- **Objective**: Establish comprehensive telemetry to support threat detection and facilitate security investigations.
- **Actions**:
  - Enable **diagnostics and activity logging**across Azure services to capture relevant operational and security data.
- **Resources**:
  - [Monitor Azure OpenAI](https://urldefense.com/v3/__https://learn.microsoft.com/en-us/azure/ai-foundry/openai/how-to/monitor-openai__;!!Jrgwm_wKFTPpVg!MmYxbo8T9xCsJA4qkZFClTNVk3jRvXvj1h8tjsJOhIdOvAvbsPneCyY9ZgQ3v_tjsW72JbHV4B3lTMPcKL9XSz0$)
  - [Enable Diagnostics settings for OpenAI](https://urldefense.com/v3/__https://learn.microsoft.com/en-us/azure/ai-services/diagnostic-logging__;!!Jrgwm_wKFTPpVg!MmYxbo8T9xCsJA4qkZFClTNVk3jRvXvj1h8tjsJOhIdOvAvbsPneCyY9ZgQ3v_tjsW72JbHV4B3lTMPcjOlAd1M$)
  - [Configure diagnostics logging for Azure AI Search](https://urldefense.com/v3/__https://learn.microsoft.com/en-us/azure/search/search-monitor-enable-logging__;!!Jrgwm_wKFTPpVg!MmYxbo8T9xCsJA4qkZFClTNVk3jRvXvj1h8tjsJOhIdOvAvbsPneCyY9ZgQ3v_tjsW72JbHV4B3lTMPcF1bc11E$)



