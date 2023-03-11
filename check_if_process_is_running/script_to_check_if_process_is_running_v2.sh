#!/bin/bash

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
    echo "Process '$1' is not running."
    return 1
  fi
}

check_process "$1"
