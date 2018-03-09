#!/bin/bash

if [ $# -lt 2 ] ; then
    echo "Please input virtual machine prefix name and number of vms"
    echo  "Usage: ./stop_vm.sh <vm_pre_name> <number_of_vm>"
else
    for loop in `seq 1 $2`
    do
      az vm stop --resource-group RoyResourceGroup  --name $1-$loop &
    done
fi
