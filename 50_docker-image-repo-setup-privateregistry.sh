#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt
MASTER_IP=`hostname -i`

DOCKERIMAGES="
flowmanager:v3
flowui:v3
flowpostgres:v3"

sudo docker login iotanalyticsregistry.azurecr.io -u iotanalyticsregistry -p Ob2S6ESPZVm7fXPsL=dWW1IN08cPGD1C

echo "now to download docker images from Azure Registry repository..."

for i in $DOCKERIMAGES; do
sleep 1
sudo docker pull iotanalyticsregistry.azurecr.io/$i
done

sudo docker images
cat /etc/docker/daemon.json

for agentIP in ${K8SAGENTS[@]}; do
    echo "now to update docker config on $agentIP ..."
    ssh  $VM_ADMIN@$agentIP "cat /etc/docker/daemon.json"
    ssh  $VM_ADMIN@$agentIP "sudo systemctl restart docker"
done

echo "now to setup local docker registry..."
sudo docker pull registry
sudo mkdir /iot_registry
sudo docker run -d -p 5000:5000 -v /iot_registry:/root/registry registry
sudo systemctl restart docker

[ $? != 0 ] && echo "docker registry setup failed!" && echo "================================================="

echo "now to upload docker images"
for i in $DOCKERIMAGES; do
sudo docker tag iotanalyticsregistry.azurecr.io/$i $MASTER_IP:5000/$i
sudo docker push $MASTER_IP:5000/$i
done


#K8S agents to pull needed images
for agentIP in ${K8SAGENTS[@]}; do
    ssh  $VM_ADMIN@$agentIP "sudo docker pull $MASTER_IP:5000/flowpostgres:v3"
    ssh  $VM_ADMIN@$agentIP "sudo docker pull $MASTER_IP:5000/flowmanager:v3"
    ssh  $VM_ADMIN@$agentIP "sudo docker pull $MASTER_IP:5000/flowui:v3"
done
