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
cat /home/vagrant/.ssh/id_rsa.pub >> /srv/sftpuser/.ssh/authorized_keys
chown root /srv/sftpuser
chmod g+rx /srv/sftpuser
mkdir -p /srv/sftpuser/data
chown sftpuser:sftpuser /srv/sftpuser/data