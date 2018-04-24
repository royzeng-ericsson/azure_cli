#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt
kubectl get nodes

kubectl get svc,pod -o wide
sleep 1

if [ "$1" ] && [ "$1" == 'delete' ]; then
    bash -x $BASE_DIR/app-k8s-deploy/flow-k8s/deploy-cleanup.sh
    sleep 2
    kubectl get svc,pod -o wide
    exit 1
fi

bash -x $BASE_DIR/app-k8s-deploy/flow-k8s/deploy-setup.sh
sleep 10

running_flag=0
while [ $running_flag -lt 3 ]; do
    running_flag=`kubectl get pod |grep -i "Running" | wc -l`
    sleep 10
done

sleep 20

kubectl get svc,pod -o wide

kubectl get nodes

