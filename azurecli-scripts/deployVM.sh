#!/bin/bash

# Script to validate your ARM template & then deploy to Azure

# assumes you have already cloned the project from git
# to do: add check for json files or git dirs, or both. also, add auth check

# to use:
# sudo bash ~/repos/scripts/deployVM.sh templateFilePath parametersFilePath resourceGroupName

DEPLOYMENT_NAME=AzureDeploy
TEMPLATE_FILE_PATH=$1
PARAMETERS_FILE_PATH=$2
RESOURCE_GROUP_NAME=$3
RESOURCE_GROUP_LOCATION= your_region_in_azure

# make group
make_resource_group()
{
    /usr/local/bin/azure group create --name $RESOURCE_GROUP_NAME --location $RESOURCE_GROUP_LOCATION
}

# validate template
validate_template()
{
    /usr/local/bin/azure group template validate --resource-group $RESOURCE_GROUP_NAME \
        --template-file $TEMPLATE_FILE_PATH --parameters-file $PARAMETERS_FILE_PATH
}

# create VM

create()
{
    /usr/local/bin/azure group deployment create --name $DEPLOYMENT_NAME --resource-group $RESOURCE_GROUP_NAME \
        --template-file $TEMPLATE_FILE_PATH --parameters-file $PARAMETERS_FILE_PATH
}

# deploy only if exit = 0 with template validation
if ! validate_template
then
  /bin/echo "FAILED"
  exit 1
else
  make_resource_group
  create
fi
