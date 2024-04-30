Vagrant.configure("2") do |config|
  # Path to the folder for SSH keys
  ssh_key_path = File.join(Dir.pwd, "ssh_keys")
  Dir.mkdir(ssh_key_path) unless Dir.exist?(ssh_key_path)

  # Creating SSH keys if they don't exist
  (1..3).each do |i|
    unless File.exist?("#{ssh_key_path}/id_rsa#{i}")
      system("ssh-keygen -t rsa -b 2048 -f #{ssh_key_path}/id_rsa#{i} -q -N ''")
    end
  end
  ips = ["192.168.50.11", "192.168.50.12", "192.168.50.13"]

  (1..3).each do |i|
    config.vm.define "sftp-server#{i}" do |ubuntu|
      ubuntu.vm.box = "ubuntu/focal64"
      ubuntu.vm.hostname = "sftp-server#{i}"
      ubuntu.vm.network "private_network", ip: ips[i-1]

      ubuntu.vm.provider "virtualbox" do |vb|
        vb.name = "ubuntu#{i}"
        vb.gui = false
        vb.memory = "2048"
        vb.cpus = 2
      end

      # Ensuring that vagrant won't create new keypair for each box
      ubuntu.ssh.insert_key = false
      # If your VM boots too long, you can change this line to ensure connections
      ubuntu.vm.boot_timeout = 360
      # Copying SSH keys and script
      ubuntu.vm.provision "file", source: "#{ssh_key_path}/id_rsa#{i}", destination: "~/.ssh/id_rsa"
      ubuntu.vm.provision "file", source: "#{ssh_key_path}/id_rsa1.pub", destination: "~/.ssh/id_rsa1.pub"
      ubuntu.vm.provision "file", source: "#{ssh_key_path}/id_rsa2.pub", destination: "~/.ssh/id_rsa2.pub"
      ubuntu.vm.provision "file", source: "#{ssh_key_path}/id_rsa3.pub", destination: "~/.ssh/id_rsa3.pub"
      ubuntu.vm.provision "file", source: "update_script.sh", destination: "~/update_script.sh"
      ubuntu.vm.provision "file", source: "python.py", destination: "~/python.py"
      ubuntu.vm.provision "shell", privileged: true, inline: <<-SHELL
        # Updating and installing required packages
        apt-get update && apt-get install -y openssh-server
        # Copying a public key for password-free access
      SHELL
      if i == 1
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa2.pub >> /home/vagrant/.ssh/authorized_keys"
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa3.pub >> /home/vagrant/.ssh/authorized_keys"
      end
      if i == 2
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa1.pub >> /home/vagrant/.ssh/authorized_keys"
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa3.pub >> /home/vagrant/.ssh/authorized_keys"
      end
      if i == 3
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa2.pub >> /home/vagrant/.ssh/authorized_keys"
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa1.pub >> /home/vagrant/.ssh/authorized_keys"
      end
      ubuntu.vm.provision "shell", inline: "chmod 600 /home/vagrant/.ssh/id_rsa"
      ubuntu.vm.provision "shell", privileged: true, inline: <<-SHELL
        chmod 600 /home/vagrant/.ssh/authorized_keys
        chmod 644 /home/vagrant/.ssh/id_rsa1.pub
        chmod 644 /home/vagrant/.ssh/id_rsa2.pub
        chmod 644 /home/vagrant/.ssh/id_rsa3.pub
        chmod 744 /home/vagrant/update_script.sh
        # Restarting SSH service
        systemctl restart ssh               
        # Installing python3 for python script if it isn't installed with box
        apt-get install python3
        # Creation of cron
        echo "*/5 * * * * /home/vagrant/update_script.sh" > /tmp/crontab_vagrant
        crontab -u vagrant /tmp/crontab_vagrant
        rm /tmp/crontab_vagrant
      
        # Restarting cron
        sudo service cron restart

      SHELL
      
      # SFTP server setup
      ubuntu.vm.provision "shell", privileged: true, path: "sftp_setup.sh"
      if i == 1
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa2.pub >> /srv/sftpuser/.ssh/authorized_keys"
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa3.pub >> /srv/sftpuser/.ssh/authorized_keys"
      end
      if i == 2
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa1.pub >> /srv/sftpuser/.ssh/authorized_keys"
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa3.pub >> /srv/sftpuser/.ssh/authorized_keys"
      end
      if i == 3
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa2.pub >> /srv/sftpuser/.ssh/authorized_keys"
      ubuntu.vm.provision "shell", inline: "cat /home/vagrant/.ssh/id_rsa1.pub >> /srv/sftpuser/.ssh/authorized_keys"
      end
      # Setting up rkhunter, log would be saved in /var/log/rkhunter.log files
      ubuntu.vm.provision "shell", privileged: true, inline: <<-SHELL
      apt-get install --yes rkhunter --no-install-recommends
      rkhunter --update
      rkhunter --propupd
      rkhunter --checkall --skip-keypress --createlogfile || true
      SHELL
    end
  end
end
