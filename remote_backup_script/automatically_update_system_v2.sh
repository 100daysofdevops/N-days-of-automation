#!/bin/bash

# Updating systems

function update_system() {
  if [[ -f /etc/redhat-release ]]; then
    
    if ! yum update -y && yum clean all; then
      echo "Error: Failed to update the system."
      return 1
    else
      echo "Ubuntu/Debian system update complete."
      return 0
    fi
    
  elif [[ -f /etc/lsb-release ]]; then

    if ! apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get autoclean -y; then
      echo "Error: Failed to update the system."
      return 1
    else
      echo "CentOS/RHEL/Fedora system update complete."
      return 0
    fi
  
  else
    
    if [ -f /etc/os-release ]; then
      . /etc/os-release
    else
      echo "Error: Unable to detect distribution type."
      return 1
    fi
  fi
}

# Call the update_system function
update_system
