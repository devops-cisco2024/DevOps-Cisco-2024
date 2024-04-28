Vagrant.configure("2") do |config|
  # Path to the folder for SSH keys
  ssh_key_path = File.join(Dir.pwd, "ssh_keys")
  Dir.mkdir(ssh_key_path) unless Dir.exist?(ssh_key_path)

  # Creating SSH keys if they don't exist
  unless File.exist?("#{ssh_key_path}/id_rsa")
    system("ssh-keygen -t rsa -b 2048 -f #{ssh_key_path}/id_rsa -q -N ''")
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
      ubuntu.vm.provision "file", source: "#{ssh_key_path}/id_rsa", destination: "~/.ssh/id_rsa"
      ubuntu.vm.provision "file", source: "#{ssh_key_path}/id_rsa.pub", destination: "~/.ssh/id_rsa.pub"
      ubuntu.vm.provision "file", source: "update_script.sh", destination: "~/update_script.sh"
      ubuntu.vm.provision "file", source: "python_script.py", destination: "~/python_script.py"

      ubuntu.vm.provision "shell", privileged: true, inline: <<-SHELL
        # Updating and installing required packages
        apt-get update && apt-get install -y openssh-server
        # Copying a public key for password-free access
        cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
        chmod 600 /home/vagrant/.ssh/authorized_keys
        chmod 600 /home/vagrant/.ssh/id_rsa
        chmod 644 /home/vagrant/.ssh/id_rsa.pub
        chmod 744 /home/vagrant/update_script.sh
        # Restarting SSH service
        systemctl restart ssh               
        # Installing python3 for python script if it isn't installed with box
        apt-get install python3
        # Creation of cron
        echo "*/1 * * * * /home/vagrant/update_script.sh" > /tmp/crontab_vagrant
        crontab -u vagrant /tmp/crontab_vagrant
        rm /tmp/crontab_vagrant
      
        # Restarting cron
        sudo service cron restart

      SHELL
      
      # SFTP server and rkhunter setup
      ubuntu.vm.provision "shell", privileged: true, path: "sftp_and_rkhunter_setup.sh"
    end
  end
end
