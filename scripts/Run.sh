#!/bin/bash
#*********************************************************************
#  Copyright (c) 2021 Siemens AG. All rights reserved.
#  Murat Tunç
#  This script aim to load the Check_System.sh to the IPC device 
#  via ssh connection.  
#*********************************************************************

#Copy script file to IPC device
bash -c "sshpass -p mutu12345 scp Check_System.sh root@192.168.130.2:/root"

#Run script file in IPC device
bash -c "sshpass -p mutu12345 ssh root@192.168.130.2 'bash -s' <Check_System.sh"