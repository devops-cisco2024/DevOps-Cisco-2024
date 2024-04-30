# Automated Log Parsing and Reporting System

## Description
This project sets up an automated system to collect, parse, and report server log data across multiple virtual machines using Vagrant, Bash, and Python. The setup includes creating virtual machines, generating and sharing SSH keys for seamless access,deploying multiple SFTP servers with restricted access, performing security audit and running scheduled tasks for log data collection and report generation.

## Components
1. **Vagrantfile**: Configures and provisions multiple virtual machines.
2. **sftp_setup.sh**: Configures and properly enables SFTP connection.
3. **update_script.sh**: Bash script for collecting log data from each machine.
4. **python.py**: Python script for parsing the collected logs and generating a report.

## Requirements
- Vagrant
- VirtualBox
- Python 3.6 or higher

## Setup and Usage

### 1. Vagrant Configuration
The `Vagrantfile` sets up three Ubuntu virtual machines, configures private network IPs, and sets up SSH keys for internal communication without passwords. Each VM is provisioned with necessary packages and scripts for the logging system through SFTP. Also it performs security audit as a part of the provisioning.

```ruby
Vagrant.configure("2") do |config|
  # Configuration details
end
```

### 2. Bash Script (update_script.sh)
This script runs on each virtual machine to collect hostname, IP address, and timestamp, saving them into a file. It then transfers these files to every other machine in the network for centralized logging.
```bash
#!/bin/bash
# Script contents
```
### 3. Python Script (python.py)
This script parses all collected logs in the central directory, aggregates data, and generates a structured report. It counts occurrences of unique server and IP address pairs and outputs a formatted report.
```python
import os
from collections import defaultdict
import datetime
# Script contents
```
## Project Structure
```
/home/vagrant/
|-- ssh_keys/      # SSH keys directory
|-- trace/         # Directory where logs are collected
|-- report/        # Directory where reports are saved
|-- sftp_setup.sh  # Bash script for configuring SFTP server
|-- update_script.sh  # Bash script for collecting logs
|-- python.py      # Python script for parsing logs and generating reports
```
## Running the Project
1. Place the Vagrantfile,sftp_setup.sh, update_script.sh, and python.py in your project directory.
2. Run vagrant up to start and provision the VMs.
3. Logs are collected and parsed automatically per the scheduled tasks set up in the Vagrant provisioners.
4. You can connect to any of the machines by writing "ssh vagrant@192.168.50.11(or 12/13 depending from the VM) after deployment.

## Additional Information
- Modify the network settings and VM specifications in the Vagrantfile as needed for your environment.
- Update the interface name in update_script.sh to match your VM network configuration.
- Ensure Python and all required packages are installed on the VMs as needed.
