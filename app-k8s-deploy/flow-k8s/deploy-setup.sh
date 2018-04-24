#!/bin/bash -x
BASE_DIR=`dirname $0`

kubectl create -f $BASE_DIR/../endpoints.yaml
kubectl create -f $BASE_DIR/../service.yaml

kubectl create -f $BASE_DIR/postgres-deployment-nfs.yaml
sleep 5
kubectl create -f $BASE_DIR/flow-ui-deployment.yaml
sleep 2
kubectl create -f $BASE_DIR/flowmanager-deployment-nfs.yaml
sleep 10
