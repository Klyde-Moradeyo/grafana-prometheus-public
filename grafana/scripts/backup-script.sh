#!/bin/bash

# Get Global Config
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $script_dir/env-config.sh
source $script_dir/helper.sh

# Configuration
MAX_RETRIES=5
RETRY_INTERVAL=60 # seconds between retries within a backup attempt
BACKUP_INTERVAL=259200
# 259200 seconds - 3 days 
# 10800 seconds - 3 hours(medium work) 
# 300 # seconds - 5 mins(while you are currently editing)

display_next_backup_time() {
    local current_time=$(date +%s)
    local next_backup_time=$((current_time + BACKUP_INTERVAL))
    local backup_time_file="$script_dir/data/next_backup_time.txt"

    # Log the next backup time
    log_message "INFO" "Next backup is scheduled for: $(date -d @$next_backup_time)"

    # Write the next backup time to the file
    if echo "$(date -d @$next_backup_time)" > "$backup_time_file"; then
        log_message "INFO" "Next backup time written to $backup_time_file"
    else
        log_message "ERROR" "Failed to write next backup time to $backup_time_file"
    fi
}

# Function to upload to S3
upload_to_s3() {
    local backup_file=$1
    # aws s3 cp "$backup_file" s3://$S3_BUCKET/$(basename "$backup_file")
}

# Function for error handling and retry logic
attempt_backup() {
    local retry_count=0
    local success=0

    while [ $retry_count -lt $MAX_RETRIES ]; do
        tar czf /tmp/$BACKUP_FILE -C $GRAFANA_DATA_PATH .

        if upload_to_s3 "/tmp/$BACKUP_FILE"; then
            log_message "INFO" "Backup successful: $BACKUP_FILE"
            rm /tmp/$BACKUP_FILE
            success=1
            break
        else
            log_message "WARNING" "Backup failed. Attempt $((retry_count + 1)) of $MAX_RETRIES."
            rm /tmp/$BACKUP_FILE
            ((retry_count++))
            sleep $RETRY_INTERVAL
        fi
    done

    if [ $success -ne 1 ]; then
        log_message "ERROR" "Backup failed after $MAX_RETRIES attempts."
        # Send failure notification here (e.g., email, webhook)
        return 1
    fi
}

# Infinite loop to run backups periodically
while true; do
    attempt_backup
    display_next_backup_time
    sleep $BACKUP_INTERVAL
done
