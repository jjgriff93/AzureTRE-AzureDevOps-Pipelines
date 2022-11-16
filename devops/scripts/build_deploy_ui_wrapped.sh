#!/bin/bash
set -e

#
# This script wraps the AzureTRE script for deploying the UI
# but removes and re-adds the Deny network rule since this causes an issues
# when deployed from an AzDO agent in the same location as the deployment
# See AzureTRE/templates/core/terraform/scripts/letsencrypt.sh for more details
#

echo "Removing default DENY rule on storage account ${STORAGE_ACCOUNT}"
az storage account update \
  --default-action Allow \
  --name "${STORAGE_ACCOUNT}" \
  --resource-group "${RESOURCE_GROUP_NAME}"

echo "Waiting for network rule to take effect"
sleep 30s

echo "Deploying UI"
# call AzureTRE Makefile
(cd AzureTRE && make build-and-deploy-ui)

echo "Resetting the default DENY rule on storage account ${STORAGE_ACCOUNT}"
az storage account update \
  --default-action Deny \
  --name "${STORAGE_ACCOUNT}" \
  --resource-group "${RESOURCE_GROUP_NAME}"
