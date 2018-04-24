#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt

echo "update docker registry config..."

if [ `grep -i "insecure" /etc/docker/daemon.json | wc -l` = 0 ]; then
    sudo sed -i '/live-restore/a\  "insecure-registries":["'"$MASTER_IP"':5000"],' /etc/docker/daemon.json
    cat /etc/docker/daemon.json
fi
sudo systemctl restart docker

echo "now to install glusterfs..."

sudo add-apt-repository ppa:gluster/glusterfs-4.0 -y
sudo apt-get update 
sudo apt-get install glusterfs-server -y
[ $? != 0 ] && echo "Glusterfs installed failed!" && exit 1

sudo ufw disable
sudo systemctl enable glusterd.service
sudo systemctl start glusterd.service

#sudo mkdir -p /glusterfs-brick/postgresdata/data
#sudo mkdir -p /glusterfs-brick/droolsdata/data

sudo mkdir -p $POSTDATAPATH/data; sudo mkdir -p $DROOLSDATAPATH/gitdir; sudo mkdir -p $FLOWPATH/runtime; sudo chmod -R 777 $GLUSTERFSROOT
