#!/bin/bash

# Function to create logs on SFTP server
sftp_logger() {
    local sftp_server=$1
    local sftp_user=$2
    local sftp_password=$3
    local filename=$4

    # Generate logs for the file
    log="Date: $(date); Server: $sftp_server \n"

    # SFTP command to create the file
    echo -e "$log" | sftp -oBatchMode=no -b - $sftp_user@$sftp_server <<EOF
    cd /path-to-dir  # TODO: Designate logs directory and specify it here
    put - "$filename"
    exit
EOF
}

# TODO: Replace vars with SFTP server details
sftp_server1="sftp_server1"
sftp_user1="user1"
sftp_password1="pass1"

sftp_server2="sftp_server2"
sftp_user2="user2"
sftp_password2="pass2"

sftp_server3="sftp_server3"
sftp_user3="user3"
sftp_password3="pass3"

# Create logs on each SFTP server
sftp_logger "$sftp_server1" "$sftp_user1" "$sftp_password1" "log_$(date +"%Y%m%d%H%M%S")"
sftp_logger "$sftp_server2" "$sftp_user2" "$sftp_password2" "log_$(date +"%Y%m%d%H%M%S")"
sftp_logger "$sftp_server3" "$sftp_user3" "$sftp_password3" "log_$(date +"%Y%m%d%H%M%S")"
