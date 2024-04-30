import os
from collections import defaultdict
import datetime

# Folder with logs
log_directory = '/srv/sftpuser/data/trace'

# Folder for reports
report_directory = '/home/vagrant/report'

# Checking the presence of the folder for reports and creating it if it is not present
if not os.path.exists(report_directory):
    os.makedirs(report_directory)

# Formatting the report file name with the current date and time
current_datetime = datetime.datetime.now().strftime("%d-%m-%Y_%H-%M-%S")
report_filename = f"report-{current_datetime}.txt"
report_path = os.path.join(report_directory, report_filename)

# Dictionary for data storage: (server_name, ip_address) -> count
data = defaultdict(int)

# Reading all log files in the specified directory
for filename in os.listdir(log_directory):
    if filename.endswith('.txt'):
        with open(os.path.join(log_directory, filename), 'r') as file:
            lines = file.readlines()
            server_name = lines[0].strip().split(': ')[1]
            ip_address = lines[1].strip().split(': ')[1]
            data[(server_name, ip_address)] += 1

# Writing a report to a file
with open(report_path, 'w') as report_file:
    # Formatting and writing column headings
    headers = ['Hostname', 'IP Address', 'Count']
    header_line = f"{headers[0].ljust(20)}{headers[1].ljust(20)}{headers[2].ljust(10)}"
    report_file.write(header_line + '\n')
    report_file.write('-' * len(header_line) + '\n')

    # Data formatting and recording
    for (server_name, ip_address), count in data.items():
        line = f"{server_name.ljust(20)}{ip_address.ljust(20)}{str(count).ljust(10)}"
        report_file.write(line + '\n')

print(f"The report was created successfully: {report_path}")
