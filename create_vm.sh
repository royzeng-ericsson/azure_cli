#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "Please input virtual machine prefix name"
elif [ $1 = "-h" -o $1 = "--help" ] ; then
    echo  "Usage: ./create_vm.sh <vm_pre_name>"
else

    for loop in 1 2 3
    do
      az vm create --resource-group RoyResourceGroup \
          --name $1-$loop \
          --image "OpenLogic:CentOS:7.4:7.4.20180118" \
          --nsg hdp-nsg \
          --size Standard_E8s_v3 \
          --ssh-key-value @eea-hdp.pub \
          --vnet-name RoyVNet --subnet default &
      sleep 5
    done
fi
