#!/bin/bash

# Email settings
EMAIL_SUBJECT="Process not running"
EMAIL_TO="you@example.com"
EMAIL_FROM="alert@example.com"

# Check if the user running the script is not root
if [ "$(id -u)" = "0" ]; then
  echo "This script must not be run as root."
  exit 1
fi

function send_email {
  # Send email using the mail command
  echo "$1" | mail -s "$EMAIL_SUBJECT" -r "$EMAIL_FROM" "$EMAIL_TO"
}

function check_process {
  # Check if the process name was provided
  if [ -z "$1" ]; then
    echo "Please provide the process name."
    return 1
  fi

  # Check if the process is running for the current user
  if pgrep -x "$1" -u "$(id -u)" >/dev/null; then
    echo "Process '$1' is running for user $(whoami)."
    return 0
  else
    echo "Process '$1' is not running for user $(whoami). Attempting to restart..."
    # Restart the process
    sudo systemctl restart $1
    sleep 5

    # Check if the process is running after restart
    if pgrep -x "$1" -u "$(id -u)" >/dev/null; then
      echo "Process '$1' restarted successfully for user $(whoami)."
      return 0
    else
      echo "Failed to restart process '$1' for user $(whoami). Sending email notification..."
      send_email "Failed to restart process '$1' for user $(whoami). Please investigate."
      return 1
    fi
  fi
}

check_process "$1"

