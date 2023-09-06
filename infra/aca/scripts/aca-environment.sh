#!/bin/bash

# ********************************************
# *****Container Apps
# ********************************************
echo "${DBG}... Creating Azure Container Apps environment [$CONTAINERAPPS_ENVIRONMENT] "
RES=$(az containerapp env create \
  --resource-group "$RESOURCE_GROUP" \
  --location "$LOCATION" \
  --name "$CONTAINERAPPS_ENVIRONMENT" \
  --logs-workspace-id "$LOG_ANALYTICS_WORKSPACE_CLIENT_ID" \
  --logs-workspace-key "$LOG_ANALYTICS_WORKSPACE_CLIENT_SECRET")

echo "${DBG}... Waiting to finalize the ACA environment"
while [ "$(az containerapp env show -n "$CONTAINERAPPS_ENVIRONMENT" -g "$RESOURCE_GROUP" --query properties.provisioningState -o tsv | tr -d '[:space:]')" != "Succeeded" ]; do sleep 10; done

CONTAINERAPPS_ENVIRONMENTID=$(az containerapp env show -n "$CONTAINERAPPS_ENVIRONMENT" -g "$RESOURCE_GROUP" --query id -o tsv |sed 's/\r$//')
echo "${OUT}... ... Azure Container Apps environment created [$CONTAINERAPPS_ENVIRONMENTID]" 

echo "${DBG}... Mount storage account [$STORAGE_ACCOUNT]"
RES=$(az containerapp env storage set --name $CONTAINERAPPS_ENVIRONMENT \
  --resource-group $RESOURCE_GROUP \
  --storage-name $FILE_SHARE \
  --azure-file-account-name $STORAGE_ACCOUNT \
  --azure-file-account-key $STORAGE_KEY \
  --azure-file-share-name $FILE_SHARE \
  --access-mode ReadWrite)

