# System Maintenance Bash Suite

Name: Shweta Pragyan G  
Roll No: 2241007001  
College: ITER, Siksha 'O' Anusandhan University

This project is a simple system maintenance toolkit written using Bash scripting. The main purpose of the project is to make regular maintenance work in Linux easier and faster. It allows the user to take backups, update the system, clean unnecessary files, and check important system logs from one place, without entering long commands each time. A menu is provided so the tasks can be selected easily.

## Tools and Technologies Used
- Bash Shell Scripting
- Linux Operating System (tested on Ubuntu)
- Commands used: tar, gzip, grep, find, df, du
- Package Managers: apt / dnf / yum
- Cron for automatic scheduling
- Git and GitHub for version control
- VS Code / Nano / Vim for editing scripts

## Main Files in the Project
1. backup.sh – Takes backup of a selected folder and stores it as a compressed file. Also removes old backups to save storage.
2. update_cleanup.sh – Updates system packages and removes unnecessary cached data to free space.
3. log_monitor.sh – Checks system log files for warnings and security issues like failed login attempts.
4. menu.sh – Shows a simple menu to run all the tasks easily.
5. test_suite.sh – Used to check if scripts are working correctly.

## Folder Structure
capstone-bash-suite/  
├── backup.sh  
├── update_cleanup.sh  
├── log_monitor.sh  
├── menu.sh  
├── test_suite.sh  
├── backups/ (this folder stores backup files)  
└── logs/ (this folder stores log reports)

## How to Run the Project
git clone https://github.com/SHWETA03610/bash-system-maintenance-suite.git
cd bash-system-maintenance-suite
chmod +x *.sh
./menu.sh

## Automation Using Cron (Optional)
If needed, tasks can run automatically at fixed times:
- Backup daily
- Update weekly
- Log monitoring daily

(These can be added using crontab.)

## Conclusion
The project reduces manual work in system maintenance and makes the process more organized. It is useful for system administrators and students who want to learn basic Linux management with scripting. It is easy to extend and can be improved based on requirements.

## Future Improvements
- Send email or mobile notifications when issues are found in logs
- Store backups to cloud storage
- Add a simple GUI instead of the menu
