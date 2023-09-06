#!/bin/bash

echo "... Loading variables"
. ./variables.sh

figlet "$INFRACODE"

echo "${DBG}... Create resource group [$RESOURCE_GROUP]"
RES=$(az group create -l $LOCATION -n $RESOURCE_GROUP)

echo "${DBG}.................................................." 
echo "${DBG}>>> Creating resources for [$INFRACODE] <<<"
echo "${DBG}.................................................." 

# ********************************************
# *****Infra
# ********************************************

echo "${DBG}... Create log analytics workspace [$LOG_ANALYTICS_WORKSPACE]"
RES=$(az monitor log-analytics workspace create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --workspace-name "$LOG_ANALYTICS_WORKSPACE")

echo "${DBG}... Retrieving log analytics client id"
LOG_ANALYTICS_WORKSPACE_CLIENT_ID=`az monitor log-analytics workspace show  \
  --resource-group "$RESOURCE_GROUP" \
  --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
  --query customerId  \
  --output tsv | tr -d '[:space:]'`

echo "${OUT}... ... $LOG_ANALYTICS_WORKSPACE_CLIENT_ID"

echo "${DBG}... Retrieving log analytics secret"
LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET=`az monitor log-analytics workspace get-shared-keys \
  --resource-group "$RESOURCE_GROUP" \
  --workspace-name "$LOG_ANALYTICS_WORKSPACE" \
  --query primarySharedKey \
  --output tsv | tr -d '[:space:]'`

echo "${OUT}... ... $LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET"


# ********************************************
# *****Storage account
# ******************************************** 
echo "${DBG}... Creating storage account [$STORAGE_ACCOUNT]" 

RES=$(az storage account create --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --sku Standard_LRS)

echo "${DBG}... Retrieving storage connection string"
STORAGE_CONNECTION_STRING=$(az storage account show-connection-string --name $STORAGE_ACCOUNT -g $RESOURCE_GROUP -o tsv)
echo "${OUT}... ... $STORAGE_CONNECTION_STRING"

echo "${DBG}... Creating file share [$FILE_SHARE]"
az storage share create -n $FILE_SHARE --connection-string $STORAGE_CONNECTION_STRING

echo "${DBG}... Retrieving storage key" 
STORAGE_KEY=$(az storage account keys list -g $RESOURCE_GROUP -n $STORAGE_ACCOUNT --query '[0].value' -o tsv) 
echo "${OUT}... ... $STORAGE_KEY"

# ********************************************
# *****Registry
# ******************************************** 

echo "${DBG}... Creating Azure Container Registry [$REGISTRY]"
RES=$(az acr create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --name "$REGISTRY" \
  --workspace "$LOG_ANALYTICS_WORKSPACE" \
  --sku Standard \
  --admin-enabled true)

echo "${DBG}... Allowing anonymous pull to Container Registry"
RES=$(az acr update \
  --resource-group "$RESOURCE_GROUP" \
  --name "$REGISTRY" \
  --anonymous-pull-enabled true)

echo "${DBG}... Retrieving Container Registry URL"
REGISTRY_URL=$(az acr show \
  --resource-group "$RESOURCE_GROUP" \
  --name "$REGISTRY" \
  --query "loginServer" \
  --output tsv)

echo "${OUT}... ... $REGISTRY_URL"