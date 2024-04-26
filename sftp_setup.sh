#! /bin/bash

# Adding sftp configs to sshd
# cat <<END >> /etc/ssh/sshd_config
cat <<END >> ~/test.txt
Match Group sftpgroup
ChrootDirectory %h
X11Forwarding no
AllowTcpForwarding no
ForceCommand internal-sftp
END
# Creating sftp group and user for it
 groupadd sftpgroup
 useradd -G sftpgroup -d /srv/sftpuser -s /sbin/nologin sftpuser
apt install openssl
openssl rand -base64 16 | passwd sftpuser
# Setting up Chroot
mkdir -p /srv/sftpuser
chown root /srv/sftpuser
chmod g+rx /srv/sftpuser
mkdir -p /srv/sftpuser/data
chown sftpuser:sftpuser /srv/sftpuser/data