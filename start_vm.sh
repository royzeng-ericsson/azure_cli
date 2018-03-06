#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "Please input virtual machine prefix name"
elif [ $1 = "-h" -o $1 = "--help" ] ; then
    echo  "Usage: ./start_vm.sh <vm_pre_name>"
else
    for loop in 1 2 3
    do
      az vm start --resource-group RoyResourceGroup  --name $1-$loop &
    done
fi