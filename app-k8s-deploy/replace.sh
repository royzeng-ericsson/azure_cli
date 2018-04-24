#!/bin/bash -x
BASE_DIR=`dirname $0`
source ../0_k8s-config.txt

for i in `ls */*.yaml`; do
    sed -i "s/$DOCKERRegistry/$MASTER_IP:5000/g" $i 
done
