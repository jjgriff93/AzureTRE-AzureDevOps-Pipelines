#!/bin/bash
set -e

#
# Script to find resource groups belonging to PRs and clean them up when the PR is no longer active
#
az config set extension.use_dynamic_install=yes_without_prompt

# Find resource groups relating to PRs
# Resource groups that start with a specific string and have the ci_git_ref tag whose value starts with "refs/pull"
az group list --query "[?starts_with(name, 'rg-tre') && tags.ci_git_ref != null && starts_with(tags.ci_git_ref, 'refs/pull')].[name, tags.ci_git_ref]" -o tsv |
while read -r rg_name rg_ref_name; do
  echo "Processing: $rg_name: $rg_ref_name"
  tmp=${rg_ref_name/refs\/pull\/}
  pr_id=${tmp/\/merge/}
  echo "Checking whether PR $pr_id is active..."

  pr_status=$(az repos pr show --org https://dev.azure.com/ouhnhsuk --id "$pr_id" --query status -o tsv)

  if [[ "$pr_status" == "active" ]]; then
    echo "Status of PR $pr_id is 'active' leaving resource group(s)"
  else
    echo "Status of PR $pr_id is '$pr_status' 🗑️ Deleting resource group(s)..."
    ./AzureTRE/devops/scripts/destroy_env_no_terraform.sh --core-tre-rg "${rg_name}" --no-wait
  fi

  echo
done


# https://docs.microsoft.com/en-gb/azure/devops/cli/azure-devops-cli-in-yaml?view=azure-devops  <--- set token in pipeline

