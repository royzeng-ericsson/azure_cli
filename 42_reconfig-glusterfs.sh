#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt
MASTER_IP=`hostname -i`

#sudo gluster volume stop $POSTGRESVOLUME
#sudo gluster volume stop $DROOLSVOLUME
#sudo gluster volume stop $FLOWPATH

/usr/bin/expect <<-EOF
set timeout 2
spawn sudo gluster volume stop $POSTGRESVOLUME
expect "(y/n)"
send "y\n"
expect eof
EOF

/usr/bin/expect <<-EOF
set timeout 2
spawn sudo gluster volume stop $DROOLSVOLUME
expect "(y/n)"
send "y\n"
expect eof
EOF

/usr/bin/expect <<-EOF
set timeout 2
spawn sudo gluster volume stop $FLOWVOLUME
expect "(y/n)"
send "y\n"
expect eof
EOF


/usr/bin/expect <<-EOF
set timeout 2
spawn sudo gluster volume delete $POSTGRESVOLUME
expect "(y/n)"
send "y\n"
expect eof
EOF

/usr/bin/expect <<-EOF
set timeout 2
spawn sudo gluster volume delete $DROOLSVOLUME
expect "(y/n)"
send "y\n"
expect eof
EOF

/usr/bin/expect <<-EOF
set timeout 2
spawn sudo gluster volume delete $FLOWVOLUME
expect "(y/n)"
send "y\n"
expect eof
EOF

echo "===================================="

sudo gluster volume info

echo "===================================="
echo "now to clean glusterfs config..."

sudo rm -rf /var/lib/glusterd/
sudo systemctl restart  glusterd.service

for agentIP in $GLUSTERAGENTS; do
    ssh -t $VM_ADMIN@$agentIP "sudo rm -rf /var/lib/glusterd/"
    ssh -t $VM_ADMIN@$agentIP "sudo systemctl restart  glusterd.service"
    ssh -t $VM_ADMIN@$agentIP "sudo rm -rf $GLUSTERFSROOT"
done

sudo rm -rf $GLUSTERFSROOT

sudo mkdir -p $POSTDATAPATH/data
sudo mkdir -p $DROOLSDATAPATH/gitdir
sudo mkdir -p $FLOWPATH/runtime
sudo chmod -R 777 $GLUSTERFSROOT

for agentIP in $GLUSTERAGENTS; do
    ssh -t $VM_ADMIN@$agentIP "sudo mkdir -p $POSTDATAPATH/data; sudo mkdir -p $DROOLSDATAPATH/gitdir sudo mkdir -p $FLOWPATH/runtime; sudo chmod -R 777 $GLUSTERFSROOT"
done
