#!/bin/bash

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Unified function for logging
log_message() {
    local log_type=$1
    local message=$2

    case "$log_type" in
        INFO)
            color=$GREEN
            ;;
        WARNING)
            color=$YELLOW
            ;;
        ERROR)
            color=$RED
            ;;
        *)
            color=$NC
            log_type="LOG"
            ;;
    esac

    echo -e "${color}[$log_type] $message${NC}"
}
