#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt
MASTER_IP=`hostname -i`


for agentIP in $AGENTS; do
    sudo  mount -t glusterfs $agentIP:/$POSTGRESVOLUME /mnt
    if [ $? != 0 ] ;then
        sudo umount /mnt
        bash -x 42_reconfig-glusterfs.sh
        echo "mount point issue on $agentIP"
        exit 1   
    else
        ls -ltar /mnt/*
        sudo mount /mnt
    fi
done

