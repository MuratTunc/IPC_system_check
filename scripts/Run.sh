#!/bin/bash
#*********************************************************************
#  Copyright (c) 2021 Siemens AG. All rights reserved.
#  Murat Tunç
#  This script aim to load the Check_System.sh to the IPC device 
#  via ssh connection.  
#*********************************************************************
SSH_PASSWORD="mutu12345"
SCRIPT_NAME="Check_System.sh"
TARGET_DEVICE_IP="192.168.130.2"
TARGET_LOCATION=":/root"
TARGET_USER="root"

#Copy script file to IPC device
bash -c "sshpass -p ${SSH_PASSWORD} scp ${SCRIPT_NAME} ${TARGET_USER}@${TARGET_DEVICE_IP}${TARGET_LOCATION}"

#Run script file in IPC device
bash -c "sshpass -p ${SSH_PASSWORD} ssh ${TARGET_USER}@${TARGET_DEVICE_IP} 'bash -s' <${SCRIPT_NAME}"