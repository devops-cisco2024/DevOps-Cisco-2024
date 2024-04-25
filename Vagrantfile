require 'fileutils'

Vagrant.configure('2') do |config|
    config_content = ""
    (1..3).each do |i|
    config.vm.define "SFTP-#{i}" do |machine|
      # Configure main
      machine.vm.box = 'ubuntu/focal64'
      machine.vm.network "private_network", ip: "192.168.100.#{9 + i}"
      machine.vm.hostname = "SFTP-#{i}"
      machine.vm.provider "virtualbox" do |vb|
        # Configure resource consumption
        vb.name = "SFTP-#{i}"
        vb.gui = false
        vb.cpus = '1'
        vb.memory = '1024'
      end
      # Creation of individual SSH key directory for each server
      ssh_key_path = File.join(Dir.pwd, "SFTP_#{i}/ssh_keys")
      FileUtils.mkdir_p(ssh_key_path) unless Dir.exist?(ssh_key_path)

      # Creation of individual keypair for each server on Windows
      unless File.exist?("#{ssh_key_path}/id_rsa")
        system("ssh-keygen -t rsa -b 2048 -f #{ssh_key_path}/id_rsa -q -N ''")
      end

      # Creating Config on host machine to manage multiple SSH keypairs on Windows
      config_content << <<~CONFIG
        Host sftp#{i}
          HostName 192.168.100.#{9 + i}
          User vagrant
          IdentityFile #{ssh_key_path}/id_rsa
      CONFIG
      # Looking for path to the config file and adding necessary strings
      config_file = File.join(File.expand_path('~/.ssh'), 'config')
      existing_content = File.exist?(config_file) ? File.read(config_file) : ""
      unless existing_content.include?(config_content)
        File.write(config_file, existing_content + config_content, mode: 'a')
      end
      # Configure SSH trading when each server is booted
      machine.vm.provision "file", source: "#{ssh_key_path}/id_rsa", destination: "~/.ssh/id_rsa"
      machine.vm.provision "file", source: "#{ssh_key_path}/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"

      machine.vm.provision "shell", privileged: true, inline: <<-SHELL
        # Updating system and installing server on guest machine
        apt-get update && apt-get install -y openssh-server
        # Copying public part of SSH key to the authorized_keys
        cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
        # Preventing non-sudo changes to the keys directory
        chmod 600 /home/vagrant/.ssh/authorized_keys
        chmod 600 /home/vagrant/.ssh/id_rsa
        chmod 644 /home/vagrant/.ssh/id_rsa.pub
        # Adding sftp configs to sshd
        cat <<END >> /etc/ssh/sshd_config
        Match Group sftpgroup
        ChrootDirectory %h
        X11Forwarding no
        AllowTcpForwarding no
        ForceCommand internal-sftp
        END 
        # Restarting SSH service to apply the changes
        systemctl restart ssh
        systemctl restart sshd
      SHELL
    end
    end
  end