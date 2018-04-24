#Run this script on the same server as deploy.sh to create ACS.

az login
az group create -n "iotregistry-group" -l westus2
az acr create -g iotregistry-group -n iotanalyticsregistry --sku Basic --admin-enabled true
az acr login -n iotanalyticsregistry
az acr show -n iotanalyticsregistry --query loginServer --output table

#Go to portal & find the password and use below command to login
docker login iotanalyticsregistry.azurecr.io -u iotanalyticsregistry -p Ob2S6ESPZVm7fXPsL=dWW1IN08cPGD1C

docker tag flowui:v1 iotanalyticsregistry.azurecr.io/flowui:v1
docker push iotanalyticsregistry.azurecr.io/flowui:v1

docker tag flowmanager:v1 iotanalyticsregistry.azurecr.io/flowmanager:v1
docker push iotanalyticsregistry.azurecr.io/flowmanager:v1

docker tag postgres:v1 iotanalyticsregistry.azurecr.io/postgres:v1
docker push iotanalyticsregistry.azurecr.io/postgres:v1

#show the image list
az acr repository list -n iotanalyticsregistry --output table
#show the tag of image
az acr repository show-tags -n iotanalyticsregistry --repository postgres --output table

