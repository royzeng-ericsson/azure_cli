#!/bin/bash -x
BASE_DIR=`dirname $0`

kubectl delete -f $BASE_DIR/flow-ui-deployment.yaml
sleep 2
kubectl delete -f $BASE_DIR/flowmanager-deployment-nfs.yaml
sleep 2
kubectl delete -f $BASE_DIR/postgres-deployment-nfs.yaml

kubectl delete -f  $BASE_DIR/../service.yaml
kubectl delete -f  $BASE_DIR/../endpoints.yaml

