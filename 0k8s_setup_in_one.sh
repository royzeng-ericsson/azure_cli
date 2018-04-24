#!/bin/bash -x

BASE_DIR=`dirname $0`
source $BASE_DIR/0_k8s-config.txt

if [ "$1" ] && [ "$1" == 'withACS' ]; then
    ssh -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $VM_ADMIN@$K8SMasterhostname "hostname -i"
    if [ $? != 0 ] ;then
        echo "Cannot login ACS hostname $K8SMasterhostname.Please check configuration files 0_k8s-config.txt,deploy.sh,parameters.json under $BASE_DIR ..."
        exit 1
    else
        bash -x $BASE_DIR/10_k8s-master-preconfig.sh
    fi
else
    if [ $ACSAGENT_NUMBER -gt 2 ]; then
        sed -i  's/"value": 2/"value": '$ACSAGENT_NUMBER'/g ' $BASE_DIR/parameters.json
    fi
#    sed -i 's/"value": "iotmaster"/"value": "'$masterDnsNamePrefix'"/g' $BASE_DIR/parameters.json
    sed -i '/masterDnsNamePrefix/{N;s|"value": ".*"|"value": "'$masterDnsNamePrefix'"|g}' parameters.json
    cat $BASE_DIR/parameters.json   
 
    echo "Start to deploy K8S clusters with below configuration:"
    read -n 1 -p "Input Y/y to continue and N/n to exit:" deploy_flag
    
    if [ $(echo $deploy_flag | tr '[a-z]' '[A-Z]') == 'Y' ] ; then
        bash -x $BASE_DIR/deploy.sh
        sleep 60
    
        count=1
        while [ $count -le 6 ]; do
            ssh -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $VM_ADMIN@$K8SMasterhostname "hostname -i"
            if [ $? != 0 ] ;then
                sleep 60
                count=`expr $count + 1 ` 
            else
                bash -x $BASE_DIR/10_k8s-master-preconfig.sh
                break
            fi
        done
        if [ $count -gt 6 ]; then
            K8SMasterIP=`nslookup $K8SMasterhostname  |tail -n 2 | head -1 | awk -F':' '{print $2}' `
            ssh -o StrictHostKeyChecking=no -i $BASE_DIR/ssh/id_rsa $VM_ADMIN@K8SMasterIP "hostname -i"
            if [ $? != 0 ]; then
                echo "Cannot ssh to $K8SMasterhostname!!! Please check configuration files and then run scirpt $BASE_DIR/10_k8s-master-preconfig.sh directly!"
            else
                sed -i 's/^K8SMasterhostname=$masterDnsNamePrefix.$resourceGroupLocation.cloudapp.azure.com/K8SMasterhostname='$K8SMasterIP'/g' $BASE_DIR/0_k8s-config.txt
                echo "Update config file,because $K8SMasterhostname cannot connect."
                cat $BASE_DIR/0_k8s-config.txt
                bash -x $BASE_DIR/10_k8s-master-preconfig.sh
            fi
        fi
    else
        exit 1
    fi
fi
