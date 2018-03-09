#!/bin/bash
VM_PRE_NAME=$1
VM_NUMBER=$2
if [ $# -lt 2 ] ; then
    echo "Please input virtual machine prefix name and number of vms"
elif [ $1 = "-h" -o $1 = "--help" ] ; then
    echo  "Usage: ./delete_vm.sh <vm_pre_name> <number_of_vm>"
else
    for loop in `seq 1 ${VM_NUMBER}`
    do
      az vm delete --resource-group RoyResourceGroup --name ${VM_PRE_NAME}-${loop} --yes
      # delete disk after vm deleted, because it cannot be done by Azure automatically.
      # Get disk name
      DiskName=`az disk list -g RoyResourceGroup --query "[].name" -o tsv | grep ${VM_PRE_NAME}-${loop}`
      # Delete disk
      az disk delete --resource-group RoyResourceGroup --yes --name ${DiskName}

    done
fi
