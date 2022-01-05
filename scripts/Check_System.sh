#!/bin/bash
#*********************************************************************
#  Copyright (c) 2021 Siemens AG. All rights reserved.
#  Murat Tunç
#*********************************************************************

RED="\033[1;31m"
GREEN="\033[1;32m"
BLUE='\033[0;34m'
NOCOLOR="\033[0m"

LOG_FILE="/var/log/swcpu_setup_bundle_install.log"
DATE_TIME="$(date +"%F %H:%M:%S")"
ADONIS_IP="192.168.73.1"
NETWORK_MASK="255.255.255.0"
UP_STATE_NETWORK_INTERFACES="..."
DOWN_STATE_NETWORK_INTERFACES="..."
VNIC_NETWORK_STATE="..."

IP_A="..."
ALL_NETWORK_INTERFACES="..."
VNIC_INTERFACE="..."


check_modules(){
    
    echo "Kernel module search is started..."
    echo "-------------------------------------------"
    OUTPUT=$(ls /lib/modules)
    echo -e "Kernel version...${GREEN}${OUTPUT}${NOCOLOR}"
    command lsmod | grep s7vmm_dev
    
    
    command lsmod | grep vnic
    
    echo "-------------------------------------------"
    echo "MAC interfaces..."
    #Get Linux and SWCPU mac numbers.
    command s7_vnic_macconfig -m /mnt/swcpu_mount
    MAC_ALL=$(s7_vnic_macconfig -m /mnt/swcpu_mount)
    SWCPU_MAC=${MAC_ALL:30:19}

    ALL_NETWORK_INTERFACES=$(ip -o link show | awk -F': ' '{print $2}')
    #echo "${ALL_NETWORK_INTERFACES}"
}

check_enp0s_exist(){
    SUB='enp0s'
    if [[ "$ALL_NETWORK_INTERFACES" == *"$SUB"* ]]; then
       VNIC_INTERFACE=$( echo "$ALL_NETWORK_INTERFACES" | tail -n1)
       echo "-------------------------------------------"
       echo -e "VNIC interface is found...${GREEN}${VNIC_INTERFACE}${NOCOLOR}"

    fi
}

ping_to_ADONIS(){
    echo "-------------------------------------------"
    ping -c 1 "$ADONIS_IP" > /dev/null
    if [ $? -eq 0 ]; then
       echo "node $ADONIS_IP is up" 
    else
       echo -e "${RED}Ping to ADONIS IP $ADONIS_IP is failed...${NOCOLOR}"
       echo "Setting ADONIS IP..."
       OUTPUT=$(s7_vnic_ipconfig --nic ${VNIC_INTERFACE} --mac ${SWCPU_MAC} --setip ${ADONIS_IP} --setmask ${NETWORK_MASK})
       echo "${OUTPUT}"
    fi

}
print_IP_A(){
    echo "-------------------------------------------"
    #Get all ip interfaces
    IP_A=$(ip a)
    echo "${IP_A}"
}

get_UP_STATE_NETWORKS(){
    echo "-------------------------------------------"
    #Get all ip interfaces
    UP_STATE_NETWORK_INTERFACES=$(ip link show | grep UP)
    echo "${UP_STATE_NETWORK_INTERFACES}"
}

check_VNIC_STATE(){

    if [[ $UP_STATE_NETWORK_INTERFACES == *"UP"* ]]; then
        VNIC_NETWORK_STATE="UP"
        echo -e "${GREEN}Vnic network interface state is UP${NOCOLOR}"
    fi


    if [[ $UP_STATE_NETWORK_INTERFACES == *"DOWN"* ]]; then
        VNIC_NETWORK_STATE="DOWN"
        echo -e "${GREEN}Vnic network interface state is DOWN${NOCOLOR}"
    fi
}

exit_program(){   
    bash -c "exit 1"
}


check_modules
print_IP_A
check_enp0s_exist
get_UP_STATE_NETWORKS
check_VNIC_STATE
ping_to_ADONIS
exit_program