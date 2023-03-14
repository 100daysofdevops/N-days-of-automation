#!/bin/bash

# Email configuration
RECIPIENT_EMAIL="receiver@example.com"
SENDER_EMAIL="sender@example.com"
EMAIL_SUBJECT="Process is not running"

function send_email {
    echo "$1" | mail -s "$EMAIL_SUBJECT" -r "$SENDER_EMAIL" "$RECIPIENT_EMAIL"
}

function check_process {
    # Check if the process name was provided
    if [ -z "$1" ]; then
        echo "Please provide the process name."
        exit 1
    fi

    # Check if the process is running
    if systemctl is-active --quiet "$1"; then
        echo "Process '$1' is running."
    else
        echo "Process '$1' is not running. Attempting to restart the process..."
        if [ "$(id -u)" != "0" ]; then
            echo "This script must be run as root to restart the process."
            exit 1
        fi
        sudo systemctl restart "$1"
        sleep 5

        # Check if process restarted successfully
        if systemctl is-active --quiet "$1"; then
            echo "Process '$1' restarted successfully"
        else
            echo "Failed to restart process '$1'. Sending email notification.."
            send_email "Failed to restart the process '$1'. Please investigate..."
            exit 1
        fi
    fi
}

check_process "$1"
