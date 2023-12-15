#!/bin/bash

# Get global Config
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source $script_dir/env-config.sh
source $script_dir/helper.sh

# Find the latest backup file in S3
# BACKUP_FILE=$(aws s3 ls s3://$S3_BUCKET/ | sort | tail -n 1 | awk '{print $4}')

if [ -z "$(aws s3 ls s3://$S3_BUCKET/$BACKUP_FILE)" ]; then
    log_message "WARNING" "No backup found in S3. Starting Grafana without restore."
else
    log_message "INFO" "Restoring Grafana from backup: $BACKUP_FILE"

    # Download the latest backup
    # aws s3 cp s3://$S3_BUCKET/$BACKUP_FILE /tmp/$BACKUP_FILE

    # # Extract the backup
    # tar xzf /tmp/$BACKUP_FILE -C $GRAFANA_DATA_PATH

    # # Clean up the downloaded file
    # rm /tmp/$BACKUP_FILE

    log_message "INFO" "Restore completed."
fi
