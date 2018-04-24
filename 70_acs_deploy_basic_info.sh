#!/bin/bash

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt
echo "==================================================="
echo "Kubernetes clusters with 1 master and $ACSAGENT_NUMBER agents have been deployed successfully."
echo "Please use account $VM_ADMIN with ssh-keys in $BASE_DIR/ssh/id_rsa to login $K8SMasterhostname."
echo "Use command <kubectl get nodes> to see details kubernetes agents information." 
echo "Flow can be accessed via port 31111. Please try to login http://localhost:31111 after port forwarding from $K8SMasterhostname."
echo  "==================================================="

