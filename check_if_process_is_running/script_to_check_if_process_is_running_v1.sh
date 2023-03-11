#!/bin/bash

# Check if the process name was provided
if [ -z "$1" ]; then
  echo "Please provide the process name."
  exit 1
fi

# Check if the process is running
if pgrep -x "$1" >/dev/null; then
  echo "Process '$1' is running."
else
  echo "Process '$1' is not running."
fi