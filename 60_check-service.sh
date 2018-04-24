#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt

if [ ! -f "$BASE_DIR/runtime.tar" ]; then
    echo "flowmanager runtime.tar doesn't exist; please check it."
    exit
else
    sudo cp -rp $BASE_DIR/runtime.tar $BASE_DIR/runtime.tar.bak
    sudo tar -xvf $BASE_DIR/runtime.tar
    sudo chmod -R 777 $BASE_DIR/runtime
fi


sudo mount -t nfs  $MASTER_IP:/$FLOWVOLUME /mnt
#sudo mount -t nfs  $agent1IP:/$FLOWVOLUME /mnt
if [ $? != 0 ]; then
    echo "failed to mount gluster volume $FLOWVOLUME on $MASTER_IP..."
    echo "try to mount from $agent1IP ...."
    sudo umount /mnt
    sudo mount -t nfs  $agent1IP:/$FLOWVOLUME /mnt
    [ $? != 0 ] && echo "failed again; please check it!" && exit 1
fi

sudo mv $BASE_DIR/runtime/* /mnt/runtime/
sudo ls -l /mnt/runtime/*
sudo umount /mnt


echo `sudo docker images | grep -i v3`
#Chek K8S agents images
for agentIP in ${K8SAGENTS[@]}; do
    ssh -t $VM_ADMIN@$agentIP "sudo docker images |grep v3"
done
