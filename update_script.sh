#!/bin/bash
# Getting the hostname
HOSTNAME=$(hostname)
# Obtaining an IP address, replace 'enp0s8' with the current interface on your system
IP_ADDRESS=$(ip addr show enp0s8 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
# Getting the date and time
DATETIME=$(date "+%d-%m-%Y %H:%M:%S")
# File name formation
FILENAME="${HOSTNAME}_$(date "+%Y%m%d%H%M%S").txt"

# Writing information to a file
echo "Server Name: $HOSTNAME" > $FILENAME
echo "IP Address: $IP_ADDRESS" >> $FILENAME
echo "Date and Time: $DATETIME" >> $FILENAME

# List of IP addresses of machines
NEIGHBORS=("192.168.50.11" "192.168.50.12" "192.168.50.13")

# Creating a trace folder on each machine via SSH and transferring the file via SFTP
for NEIGHBOR in ${NEIGHBORS[@]}; do
    if [[ "$IP_ADDRESS" != "$NEIGHBOR" ]]; then
        sftp -o StrictHostKeyChecking=no sftpuser@$NEIGHBOR << EOF
put $FILENAME /data/trace/$FILENAME
EOF
    fi
done
# Deleting a local file
rm $FILENAME