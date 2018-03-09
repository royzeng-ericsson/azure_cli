#!/bin/bash

if [ $# -lt 2 ] ; then
    echo "Please input virtual machine prefix name and number of vms"
    echo  "Usage: ./restart_vm.sh <vm_pre_name> <number_of_vm>"
else
    for loop in `seq 1 $2`
    do
      az vm restart --resource-group RoyResourceGroupIreland  --name $1-$loop &
    done
fi
