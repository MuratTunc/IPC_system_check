#!/bin/bash
#*********************************************************************
#  Copyright (c) 2021 Siemens AG. All rights reserved.
#  Murat Tunç
#*********************************************************************

LOG_FILE="/var/log/swcpu_setup_bundle_install.log"

DATE_TIME="$(date +"%F %H:%M:%S")"


function check_modules(){
    
    bash -c "lsmod | grep s7vmm_dev"
    bash -c "sleep 2"
    bash -c $CHECK_VNIC_COMMAND
}

function exit_program(){
    
    bash -c "exit 1"
    
}


check_modules
exit_program