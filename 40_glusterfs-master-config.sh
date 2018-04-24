#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt
MASTER_IP=`hostname -i`

sudo gluster --version
[ $? != 0 ] && echo "Glusterfs installed failed!" && exit 1

sudo apt-get install expect -y
[ $? != 0 ] && echo "expect installed failed!"

echo "now to setup gluster pools..."

sudo gluster peer status
for agentIP in $GLUSTERAGENTS; do
    sudo gluster peer probe $agentIP
done
sudo gluster peer status

echo "now to create glusterfs volume..."

sleep 1

sudo gluster volume create $POSTGRESVOLUME replica 3 $MASTER_IP:$POSTDATAPATH $agent1IP:$POSTDATAPATH $agent2IP:$POSTDATAPATH force

sleep 3

sudo gluster volume create $DROOLSVOLUME replica 3 $MASTER_IP:$DROOLSDATAPATH $agent1IP:$DROOLSDATAPATH $agent2IP:$DROOLSDATAPATH force

sleep 3
sudo gluster volume create $FLOWVOLUME replica 3 $MASTER_IP:$FLOWPATH $agent1IP:$FLOWPATH $agent2IP:$FLOWPATH force

sleep 2


#sudo gluster volume set  $POSTGRESVOLUME nfs.disable off 
#sudo gluster volume set  $DROOLSVOLUME  nfs.disable off 
#sudo gluster volume set  $FLOWMANAGERVOLUME  nfs.disable off 




/usr/bin/expect <<-EOF
set timeout 2
spawn sudo gluster volume set $POSTGRESVOLUME nfs.disable off
expect "(y/n)"
send "y\n"
expect eof
EOF

sleep 2

/usr/bin/expect <<-EOF
set timeout 2
spawn sudo gluster volume set $DROOLSVOLUME nfs.disable off
expect "(y/n)"
send "y\n"
expect eof
EOF

sleep 2

/usr/bin/expect <<-EOF
set timeout 2
spawn sudo gluster volume set $FLOWVOLUME nfs.disable off
expect "(y/n)"
send "y\n"
expect eof
EOF

sleep 1

sudo gluster volume start  $POSTGRESVOLUME && sleep 6
sudo gluster volume start  $DROOLSVOLUME && sleep 6
sudo gluster volume start  $FLOWVOLUME && sleep 8

sudo gluster peer status
sudo gluster volume info

/usr/bin/expect <<-EOF
set timeout 2
spawn sudo gluster volume stop $FLOWVOLUME
expect "(y/n)"
send "y\n"
expect eof
EOF
sleep 8

#sudo gluster volume stop $FLOWVOLUME
sudo gluster volume start  $FLOWVOLUME 
