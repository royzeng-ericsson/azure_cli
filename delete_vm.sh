#!/bin/bash

if [ $# -lt 2 ] ; then
    echo "Please input virtual machine prefix name and number of vms"
elif [ $1 = "-h" -o $1 = "--help" ] ; then
    echo  "Usage: ./delete_vm.sh <vm_pre_name> <number_of_vm>"
else
    for loop in `seq 1 $2`
    do
      az vm delete --resource-group RoyResourceGroup --name $1-$loop --yes
      # delete disk after vm deleted, it cannot be done by Azure automatically.
      # Get disk name
      DiskName = `az disk list -g RoyResourceGroup --query "[].name" -o tsv | grep $1-$loop`
      # Delete disk
      az disk delete --resource-group RoyResourceGroup --yes --name ${DiskName}

    done
fi
