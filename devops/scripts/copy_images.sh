#!/bin/bash

# $1 is target ACR name passed from command line when calling this script
# $2 is the name of the image being processed. result for do-loop over list produced by list_images_with_tags.sh

# usage: copy_image.sh <target-acr-name>

./devops/scripts/list_images_with_tags.sh |

while read image;
do
  echo "Importing $image to $1..."
  az acr import \
    --name "$1" \
    --source "acrdevci.azurecr.io/$image" \
    --image "$image" \
    --username "$DEV_CICD_ARM_CLIENT_ID" \
    --password "$DEV_CICD_ARM_CLIENT_SECRET" \
    --force
done
