#!/bin/bash

if [ $# -lt 2 ] ; then
    echo "Please input virtual machine prefix name and number of vms"
elif [ $1 = "-h" -o $1 = "--help" ] ; then
    echo  "Usage: ./create_vm.sh <vm_pre_name> <number_of_vm>"
else

    for loop in `seq 1 $2`
    do
      az vm create --resource-group RoyResourceGroup \
          --name $1-$loop \
          --image "RHEL" \
          --nsg hdp-nsg \
          --size Standard_E8s_v3 \
          --ssh-key-value @eea-hdp.pub \
          --vnet-name RoyVNet --subnet default &
      sleep 5
    done
fi
