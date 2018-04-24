#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt


curl_flag=1

for i in `seq 10`; do
   curl localhost:31111
   curl_flag=$?
   if [ $curl_flag == 0 ]; then
       exit 0
   else
       sleep 10
   fi

done

bash -x $BASE_DIR/61_flow-deploy.sh delete
bash -x $BASE_DIR/61_flow-deploy.sh

curl localhost:31111
if [ $? != 0 ]; then
    echo "Failed to deploy flow into K8S. Please check it."
    exit 1
fi
