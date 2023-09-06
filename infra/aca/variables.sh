#!/bin/bash

SID="c1537527-c126-428d-8f72-1ac9f2c63c1f"
az account set --subscription $SID

INFRACODE="acajobs"
LOCATION="westeurope"
RESOURCE_GROUP="rg-${INFRACODE}"
FILE_SHARE="dabconfig"
DABCONFIGFOLDER="./${FILE_SHARE}/"


#output values
OUT='\033[0;37m'
#debug
DBG='\033[0;32m'


#--------------------------------
#--- shared infra
#--------------------------------

# azure container registry
REGISTRY="${INFRACODE}"

WHITE='\033[0;37m' 
RED='\033[0;31m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'


#--------------------------------
#--- aca environment
#--------------------------------

# container apps environment
CONTAINERAPPS_ENVIRONMENT="${INFRACODE}-env"
# log analytics workspace
LOG_ANALYTICS_WORKSPACE="${INFRACODE}-lga"
# azure storage account
STORAGE_ACCOUNT="${INFRACODE}"