#!/bin/bash
#*********************************************************************
#  Copyright (c) 2021 Siemens AG. All rights reserved.
#  Murat Tunç
#*********************************************************************

LOG_FILE="/var/log/swcpu_setup_bundle_install.log"

DATE_TIME="$(date +"%F %H:%M:%S")"


check_modules(){
    
    echo "Kernel module search is started..."
    command lsmod | grep s7vmm_dev
    command sleep 1
    command lsmod | grep vnic
}

exit_program(){
    
    bash -c "exit 1"
    
}


check_modules
exit_program