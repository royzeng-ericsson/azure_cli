#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt
chmod 600 $BASE_DIR/ssh/id_rsa
scp -rp -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $BASE_DIR/ssh/id* $VM_ADMIN@$K8SMasterhostname:/home/$VM_ADMIN/.ssh/
scp -rp -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $BASE_DIR/0_k8s-config.txt $VM_ADMIN@$K8SMasterhostname:/home/$VM_ADMIN/
scp -rp -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $BASE_DIR/2* $VM_ADMIN@$K8SMasterhostname:/home/$VM_ADMIN/
scp -rp -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $BASE_DIR/3* $VM_ADMIN@$K8SMasterhostname:/home/$VM_ADMIN/
scp -rp -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $BASE_DIR/4* $VM_ADMIN@$K8SMasterhostname:/home/$VM_ADMIN/
scp -rp -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $BASE_DIR/5* $VM_ADMIN@$K8SMasterhostname:/home/$VM_ADMIN/
scp -rp -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $BASE_DIR/app-k8s-deploy $VM_ADMIN@$K8SMasterhostname:/home/$VM_ADMIN/
scp -rp -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $BASE_DIR/6*  $VM_ADMIN@$K8SMasterhostname:/home/$VM_ADMIN/
scp -rp -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $BASE_DIR/runtime.tar  $VM_ADMIN@$K8SMasterhostname:/home/$VM_ADMIN/

sleep 10

echo "Now to trigger scripts run on k8s master..."

ssh -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $VM_ADMIN@$K8SMasterhostname "bash -x /home/$VM_ADMIN/20_sshkey-deploy-glusterfs-trigger.sh"

if [ $? = 0 ]; then
    bash 70_acs_deploy_basic_info.sh
fi
