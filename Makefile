
SHELL:=/bin/bash

AZURETRE_HOME?=./AzureTRE

include $(AZURETRE_HOME)/Makefile


# Add your make commands down here

build-and-deploy-ui-wrapped:
# Call local wrapper script until https://github.com/microsoft/AzureTRE/issues/2506 is resolved
	echo "=========== Starting build-and-deploy-ui-wrapped ==========="
	source ${AZURETRE_HOME}/devops/scripts/check_dependencies.sh nodocker,env,auth \
	&& pushd ${AZURETRE_HOME}/templates/core/terraform/ > /dev/null && source ./outputs.sh && popd > /dev/null \
	&& source ${AZURETRE_HOME}/devops/scripts/load_env.sh ${AZURETRE_HOME}/templates/core/private.env \
	&& if [ "$${DEPLOY_UI}" == "true" ]; then ./devops/scripts/build_deploy_ui_wrapped.sh; else echo "UI Deploy skipped as DEPLOY_UI not true"; fi \
