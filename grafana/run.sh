#!/bin/bash

# Get global Config
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $script_dir/scripts/helper.sh

# Run the restore script
log_message "INFO" "Starting Grafana restore process."
./scripts/restore-script.sh

# Check and start the backup process in the background
log_message "INFO" "Initializing backup process."
./scripts/watchdog.sh &

# Start Grafana
log_message "INFO" "Starting Grafana."
/run.sh  # Assuming /run.sh is your script to start Grafana
