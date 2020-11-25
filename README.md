---
page_type: sample
languages:
- tsql
- sql
- csharp
products:
- azure-sql-database
- azure
- dotnet
- dotnet-core
description: "Monitor GeoFences in real-time using Azure SQL and Stream Analytics"
urlFragment: "azure-sql-db-serverless-geospatial-stream-analytics"
---

# Monitor GeoFences in real-time using Azure SQL and Stream Analytics

<!-- 
Guidelines on README format: https://review.docs.microsoft.com/help/onboard/admin/samples/concepts/readme-template?branch=master

Guidance on onboarding samples to docs.microsoft.com/samples: https://review.docs.microsoft.com/help/onboard/admin/samples/process/onboarding?branch=master

Taxonomies for products and languages: https://review.docs.microsoft.com/new-hope/information-architecture/metadata/taxonomies?branch=master
-->

![License](https://img.shields.io/badge/license-MIT-green.svg)

A fully working end-to-end solution, to process incoming real-time public transportation data by sending them to Event Hub and then processing the stream using Stream Analytics and Azure SQL.

Stream Analytics will read geofencing definition from Azure SQL and check if a bus is withing a defined geofence in real-time. The results will be then stored into Azure SQL for further processing and analysis. 

## How it works

The sample uses local console application to monitor Real-Time Public Transportation Data, available as [GTFS-Realtime Feed](https://gtfs.org/reference/realtime/v2/) and published by several public transportation companies like, for example, the [King County Metro](https://kingcounty.gov/depts/transportation/metro/travel-options/bus/app-center/developer-resources.aspx).

Every 15 seconds the application will wake up and get the GTFS Realtime Feed. It will send data to Event Hub, creating one event per Bus data. Stream Analytics will process the incoming stream, checking if a bus is within a Geofence (stored in `dbo.GeoFences` table and configured as a Reference Source Data).

## Pre-Requisites

An Azure SQL database is needed. The database will not be created by the deployment script. If you need help to create an Azure SQL database, take a look here: [Running the samples](https://github.com/yorek/azure-sql-db-samples#running-the-samples). 

## Create Database and import Route static data

The GTFS Realtime feed will give you data with some values that needs to be decoded like, for example, the `RouteId`. In order to transform such Id into something meaningful, like the Route name (eg. 221 Education Hill - Crossroads - Eastgate).

In an existing Azure SQL database, run the `./sql/00-create-obejcts.sql` script to create needed tables.

You can download the static data zip file from here [King County Metro GTFS Feed Zip File](https://kingcounty.gov/depts/transportation/metro/travel-options/bus/app-center/developer-resources.aspx) and then you can import it into the `dbo.Routes` table using the Import capabilities of [SQL Server Management Studio](https://docs.microsoft.com/en-us/sql/relational-databases/import-export/import-flat-file-wizard), [Azure Data Studio](https://docs.microsoft.com/en-us/sql/azure-data-studio/extensions/sql-server-import-extension) or just using BULK LOAD as in script `./sql/01-import-csv.sql`

## Deploy on Azure

The script `./azure-deploy.sh` will take care of everything. Make sure you set the correct values for you subscription in the `.env` file for:

```
resourceGroup=""
storageName=""
location="" 
sqlServer=""
sqlDatabase=""
sqlUser=""
sqlPassword=""
eventhubsNamespace="azdbeh1"
storageAccount="azdbasa"
```

The script has been tested on Linux Ubuntu and the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/) or the [Cloud Shell](https://shell.azure.com/).

The following resources will be created for you:

- Azure Event Hubs
- Azure Storage Account
- Azure Stream Analytics

## Run the GTFS to Event Hub application 

To start to send data to Event Hubs, run the application in `./eh-gtfs` folder. Before running the application make sure to create a `./eh-gtfs/.env` file (from the provided template) and specify the correct value for the `EventHubConnectionString` setting. The value is the Event Hub *namespace* connection string. If you deployed the sample using the provided `./azure-deploy.sh` script, such connection string is shown at the end of the script execution.

```bash
cd ./eh-gtfs
dotnet run
```

The application will connect to King County Metro public data feed and send it to Event Hubs to simulate a stream of geospatial data.

If you want something working 100% on Azure, without the need to run something locally, you can re-write the provided code as Azure Function or deploy the existing console application into an Azure Container Instance

## Alternative Solution

An alterative solution, which also shows how to plot geospatial data on a map, can be found here:

https://github.com/Azure-Samples/azure-sql-db-serverless-geospatial

## Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.opensource.microsoft.com.

When you submit a pull request, a CLA bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., status check, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
