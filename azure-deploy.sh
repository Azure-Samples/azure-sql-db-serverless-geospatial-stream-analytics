#!/bin/bash

set -euo pipefail

# Requirements: 
# - AZ CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

# Azure configuration
FILE=".env"
if [[ -f $FILE ]]; then
	echo "Loading from .env" 
    export $(egrep . $FILE | xargs -n1)
else
	cat << EOF > .env
resourceGroup=""
storageName=""
location=""
sqlServer=""
sqlDatabase=""
sqlUser=""
sqlPassword=""
eventhubsNamespace="azdbeh1"
storageAccount="azdbasa"
EOF
	echo "Enviroment file not detected."
	echo "Please configure values for your environment in the created .env file"
	echo "and run the script again."
	exit 1
fi

echo "Creating Resource Group...";
az group create \
    -n $resourceGroup \
    -l $location

echo "Deploying ARM template...";
az deployment group create \
    -g $resourceGroup \
    --template-file ./azure-resources.json \
    --parameters location=$location \
    --parameters sqlServer=$sqlServer \
    --parameters sqlDatabase=$sqlDatabase \
    --parameters sqlUser=$sqlUser \
    --parameters sqlPassword=$sqlPassword \
    --parameters eventhubsNamespace=$eventhubsNamespace \
    --parameters storageAccount=$storageAccount

echo "Event Hubs Connection String"
 az eventhubs namespace authorization-rule keys list \
    -n RootManageSharedAccessKey \
    --namespace-name $eventhubsNamespace \
    -g $resourceGroup \
    --query "primaryConnectionString"



    

