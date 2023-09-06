#!/bin/bash

PROJECT="crondapr"
MIN=1
MAX=3
IMAGE="hello-controller"
TAG="0.1.3"

# ********************************************
# *****Container App
# ********************************************
  
# ----------> create ACA application

echo "${DBG}... Create ACA app [$PROJECT] - tag [$TAG] - Environment [$CONTAINERAPPS_ENVIRONMENT]"

RES=$(az deployment group create \
  -g $RESOURCE_GROUP \
  -f ./bicep/aca-app.bicep \
  -p appName=$PROJECT acaEnvironmentName=$CONTAINERAPPS_ENVIRONMENT minReplicas=$MIN maxReplicas=$MAX tag=$TAG)

#echo $RES

PROJECT="cronjob"
IMAGE="hello-worker"
TAG="3.4.6"

echo "${DBG}... Create ACA app [$PROJECT] - tag [$TAG] - Environment [$CONTAINERAPPS_ENVIRONMENT]"

RES=$(az deployment group create \
  -g $RESOURCE_GROUP \
  -f ./bicep/aca-job.bicep \
  -p appName=$PROJECT acaEnvironmentName=$CONTAINERAPPS_ENVIRONMENT tag=$TAG)