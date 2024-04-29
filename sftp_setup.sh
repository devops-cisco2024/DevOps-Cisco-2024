#! /bin/bash

echo "Match Group sftpgroup
ChrootDirectory %h
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp" >> /etc/ssh/sshd_config
# Creating sftp group and user for it
groupadd sftpgroup
useradd -G sftpgroup -d /srv/sftpuser -s /sbin/nologin sftpuser
PASSWD=$(date | md5sum | cut -c1-8)
echo "sftpuser:$PASSWD" | chpasswd
# Setting up Chroot
mkdir -p /srv/sftpuser/.ssh
chown root /srv/sftpuser
chmod g+rx /srv/sftpuser
mkdir -p /srv/sftpuser/data/trace
chown -hR sftpuser:sftpuser /srv/sftpuser/data

# Restarting sshd server to be able to connect via sftp without errors
systemctl restart sshd