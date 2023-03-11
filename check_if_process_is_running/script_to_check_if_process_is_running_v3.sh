#!/bin/bash

# Email configuration
EMAIL_TO="reciever@example.com"
EMAIL_FROM="sender@example.com"
EMAIL_SUBJECT="process is not running"

function send_email {
    echo "$1" | mail -s "EMAIL_SUBJECT" -r "EMAIL_FROM" "EMAIL_TO" 
}

function check_process {
  # Check if the process name was provided
  if [ -z "$1" ]; then
    echo "Please provide the process name."
    return 1
  fi

  # Check if the process is running
  if pgrep -x "$1" >/dev/null; then
    echo "Process '$1' is running."
    return 0
    else
      echo "Process '$1' is not running. Attempting to restart the process..."
      sudo systemctl restart $1
      sleep 5

    # Check if process restarted sucesfully

    if pgrep -x "$1" >/dev/null; then
        echo "Process '$1' restarted sucesfully"
    else
        echo "Failed to restart process '$1'. Sending email notification.."
        send_email "Failed to restart the process '$1'. Please investigate..."
        return 1
    fi        

  fi
}

check_process "$1"