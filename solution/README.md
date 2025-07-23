# Claims Denial Navigator  Installation Guide

This guide provides a comprehensive overview of how to install the Claims Denial Navigator  Power Apps solution. Follow the steps below to set up the necessary resources and import the solution.

## Prerequisites

Before you begin, ensure you have the following:
- Azure Resources created with the script found in azureresources folder
- A SharePoint site made to the specifications found on the main README

## Downloading the Claims Denial Navigator  App
Download the zip file in this folder.

## Import the Claims Denial Navigator  App

1. In a web browser, navigate to [Power Apps](https://make.preview.powerapps.com/).

2. Sign in with credentials with Admin access.

3. In the menu on the left, select Solutions.

4. Click Import Solution and select the Power App package ClaimsNavigator.zip
![Claims Denial Navigator  Import](/assets/appuploadsolution.png)

5. Click next until you reach Connections. Update the connections as needed until all 5 connections have a green check mark next to them.
![Claims Denial Navigator  Connections](/assets/appconnections.png)

6. Fill out the Enviormental Variables and select Import and wait until the process is complete
![Claims Denial Navigator  Variables](/assets/appenvvariable.png)

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


