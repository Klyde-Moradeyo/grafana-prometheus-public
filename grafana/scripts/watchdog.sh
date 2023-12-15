#!/bin/bash

# Get global Config
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $script_dir/helper.sh

# Configuration
CHECK_INTERVAL=300 # seconds - 5 minutes
BACKUP_SCRIPT_PATH="$script_dir/backup-script.sh"
NEXT_BACKUP_TIME_FILE="$script_dir/data/next_backup_time.txt"

# Function to check if the backup script is running
is_backup_running() {
    pgrep -f "$BACKUP_SCRIPT_PATH" > /dev/null
}

# Function to start the backup script
start_backup() {
    nohup "$BACKUP_SCRIPT_PATH" &
}

# Function to read the next backup time from the file
read_next_backup_time() {
    if [[ -f "$NEXT_BACKUP_TIME_FILE" ]]; then
        local next_backup_time=$(cat "$NEXT_BACKUP_TIME_FILE")
        log_message "INFO" "Next backup is scheduled for: $next_backup_time"
    else
        log_message "WARNING" "Next backup time file not found."
    fi
}

# Infinite loop to monitor the backup script
while true; do
    if is_backup_running; then
        log_message "INFO" "Backup process is running."
    else
        log_message "WARNING" "Backup process is not running. Starting it now..."
        start_backup
    fi
    # Read and log the next backup time
    read_next_backup_time
    sleep $CHECK_INTERVAL
done
