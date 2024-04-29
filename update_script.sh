#!/bin/bash

# Get the current server name
server_name=$(hostname)

# Get the current server IP address
server_ip=$(hostname -I | awk '{print $1}')

# Create a log file with the server name and IP
log_file="/home/vagrant/trace/${server_name}_${server_ip}.txt"
echo "Server Name: ${server_name}" > "${log_file}"
echo "IP Address: ${server_ip}" >> "${log_file}"

# SFTP server IPs
server1_ip="192.168.50.11"
server2_ip="192.168.50.12"
server3_ip="192.168.50.13"

# Function to upload log file to SFTP server
upload_log_file() {
    local sftp_server_ip=$1
    local sftp_user="sftpuser"
    local sftp_password=$(date +%s | sha256sum | base64 | head -c 8)

    # Use sshpass to provide the password for SFTP
    sshpass -p "${sftp_password}" sftp "${sftp_user}@${sftp_server_ip}" <<EOF
put "${log_file}" "/srv/sftpuser/data/trace/${server_name}_${server_ip}.txt"
EOF
}

# Upload log file to other servers based on the current server's IP
case "${server_ip}" in
    "${server1_ip}")
        upload_log_file "${server2_ip}"
        upload_log_file "${server3_ip}"
        ;;
    "${server2_ip}")
        upload_log_file "${server1_ip}"
        upload_log_file "${server3_ip}"
        ;;
    "${server3_ip}")
        upload_log_file "${server1_ip}"
        upload_log_file "${server2_ip}"
        ;;
    *)
        echo "Invalid server IP address"
        exit 1
        ;;
esac
