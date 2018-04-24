#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt

#install glusterfs on master
mkdir logs
bash -x /home/$VM_ADMIN/30_glusterfs-install.sh >/home/$VM_ADMIN/logs/30_glusterfs-install.log

#Copy ssh-key to k8s agents
for agentIP in ${K8SAGENTS[@]}; do
    scp -rp -o StrictHostKeyChecking=no $HOME/.ssh/id* $VM_ADMIN@$agentIP:/home/$VM_ADMIN/.ssh/
    scp -rp -o StrictHostKeyChecking=no $HOME/0_k8s-config.txt  $VM_ADMIN@$agentIP:/home/$VM_ADMIN/
    scp -rp -o StrictHostKeyChecking=no $HOME/30_glusterfs-install.sh $VM_ADMIN@$agentIP:/home/$VM_ADMIN/
    scp -rp -o StrictHostKeyChecking=no $HOME/50_docker-image-repo-setup* $VM_ADMIN@$agentIP:/home/$VM_ADMIN/
done

#install and setup glusterfs on k8s agents
for agentIP in ${K8SAGENTS[@]}; do
  echo "now to install gulsterfs on $agentIP ..."
  ssh -t $VM_ADMIN@$agentIP "bash -x /home/$VM_ADMIN/30_glusterfs-install.sh >/home/$VM_ADMIN/30_log.txt"

done

#config glusterfs on current k8s master

bash -x /home/$VM_ADMIN/40_glusterfs-master-config.sh >/home/$VM_ADMIN/logs/40_glusterfs-master-config.log
#download image & setup private repositry on master
bash -x /home/$VM_ADMIN/50_docker-image-repo-setup-privateregistry.sh >/home/$VM_ADMIN/logs/50_privateregistry-log.txt


bash -x /home/$VM_ADMIN/60_check-service.sh >/home/$VM_ADMIN/logs/60_check-service.log

bash -x /home/$VM_ADMIN/61_flow-deploy.sh
bash -x /home/$VM_ADMIN/62_flow-connect-test.sh
