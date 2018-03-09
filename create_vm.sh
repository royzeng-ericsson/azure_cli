#!/bin/bash

VM_PRE_NAME=$1
VM_NUMBER=$2

if [ $# -lt 2 ] ; then
    echo "Please input virtual machine prefix name and number of vms"
    echo  "Usage: ./create_vm.sh <vm_pre_name> <number_of_vm>"
else

    for loop in `seq 1 ${VM_NUMBER}`
    do
      #az vm create --resource-group RoyResourceGroupIreland \
      az vm create \
          --name ${VM_PRE_NAME}-${loop} \
          --admin-username redhat \
          --image "RHEL" \
          --nsg hdp-nsg-ireland \
          --size Standard_E8s_v3 \
          --ssh-key-value @eea-hdp.pub \
          --vnet-name RoyVnetIreland --subnet default &
      sleep 5
    done
fi
