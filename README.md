# Log Parser

## Description
This script is designed to analyze log files from a specified directory. It reads text log files, extracts information about servers and IP addresses, and then counts the occurrences of unique (server name, IP address) pairs. The results are saved in a report file in a separate directory marked with the current date and time.

## Requirements
- Python 3.6 or higher
- An operating system with command line support

## Project Structure
- /home/vagrant/ # Main project directory
- |-- trace/ # Directory containing log files
- |-- report/ # Directory for saving reports


## How to Use
1. Ensure all log files are placed in the `/home/vagrant/trace/` directory.
2. Run the script with the command:
   ```bash
   python3 python.py

After the script executes, a report file named report-DD-MM-YYYY_HH-MM-SS.txt will be created in the /home/vagrant/report/ directory, where DD-MM-YYYY and HH-MM-SS represent the date and time the report was generated.

Configuration
To change the directories for logs and reports, modify the log_directory and report_directory variables in the script.

Usage Examples
After running the script, you will obtain a report file that includes the following columns:

- Hostname - the server name
- IP Address - the server's IP address
- Count - the number of times this particular pair (server name, IP address) appears in the logs
