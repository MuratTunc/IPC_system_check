#!/bin/bash
#*********************************************************************
#  Copyright (c) 2021 Siemens AG. All rights reserved.
#  Murat Tunç
#*********************************************************************

LOG_FILE="/var/log/swcpu_setup_bundle_install.log"

DATE_TIME="$(date +"%F %H:%M:%S")"

IP_A="..."


check_modules(){
    
    echo "Kernel module search is started..."

    OUTPUT=$(ls /lib/modules)
    echo "${OUTPUT}"

    command lsmod | grep s7vmm_dev
    
    
    command lsmod | grep vnic
    
    #Get Linux and SWCPU mac numbers.
    command s7_vnic_macconfig -m /mnt/swcpu_mount
    MAC_ALL=$(s7_vnic_macconfig -m /mnt/swcpu_mount)
    SWCPU_MAC=${MAC_ALL:30:19}
    echo "${SWCPU_MAC}"

    #Get all ip interfaces
    IP_A=$(ip a)
    echo "${IP_A}"


}

check_enp0s_exist(){
    SUB='enp0s'
    if [[ "$IP_A" == *"$SUB"* ]]; then
       echo "It's there."
    fi
}

exit_program(){
    
    bash -c "exit 1"
    
}


check_modules
check_enp0s_exist
exit_program