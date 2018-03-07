#!/bin/bash

if [ $# -lt 1 ] ; then
    echo "Please input virtual machine name "
elif [ $1 = "-h" -o $1 = "--help" ] ; then
    echo  "Usage: ./get_ip.sh <vm_name>"
else
    for loop in `seq 1 $2`
    do
      az vm list-ip-addresses --resource-group RoyResourceGroup -n $1
    done
fi
