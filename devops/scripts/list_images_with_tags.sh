#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset
# set -o xtrace

function template_version () {
	version=$(yq eval ".version" "$1")
	name=$(yq eval ".name" "$1")
	echo -e "$name:v$version"
	echo -e "$name-installer:v$version"
}

function python_version () {
	version=$(grep "=" $2 | sed -r 's/__version__ = "([0-9.]*)"/\1/g')
	echo -e "microsoft/azuretre/$1:$version"
}

cd AzureTRE

#
# Core images
#
python_version "api" "api_app/_version.py"
python_version "resource-processor-vm-porter" "resource_processor/_version.py"
python_version "airlock-processor" "airlock_processor/_version.py"

#
# Shared service bundles
#
template_version "templates/shared_services/certs/porter.yaml"
template_version "templates/shared_services/firewall/porter.yaml"
template_version "templates/shared_services/sonatype-nexus-vm/porter.yaml"
template_version "templates/shared_services/gitea/porter.yaml"

#
# Workspace bundles
#
template_version "templates/workspaces/base/porter.yaml"
template_version "templates/workspaces/airlock-import-review/porter.yaml"
template_version "templates/workspace_services/guacamole/porter.yaml"
template_version "templates/workspace_services/azureml/porter.yaml"
template_version "templates/workspace_services/innereye/porter.yaml"
template_version "templates/workspace_services/gitea/porter.yaml"
template_version "templates/workspace_services/mlflow/porter.yaml"
template_version "/workspaces/ouhtre_deployment/templates/workspace_services/guacamole/user_resources/guacamole-azure-windowsvm-ouh/porter.yaml"
template_version "/workspaces/ouhtre_deployment/templates/workspace_services/guacamole/user_resources/guacamole-azure-linuxvm-ouh/porter.yaml"
template_version "templates/workspace_services/guacamole/user_resources/guacamole-azure-import-reviewvm/porter.yaml"
template_version "templates/workspace_services/guacamole/user_resources/guacamole-azure-export-reviewvm/porter.yaml"

#
# guac-server is required by the Guacamole Workspace Service
#
python_version "guac-server" "templates/workspace_services/guacamole/guacamole-server/docker/version.txt"

