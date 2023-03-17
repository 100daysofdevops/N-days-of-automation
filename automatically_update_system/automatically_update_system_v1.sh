#!/bin/bash

# Updating Ubuntu/Debian systems
function update_ubuntu_debian() {
  # Update package list, upgrade packages, apply security updates,remove unused packages, and clean up package cache
  if ! apt-get update -y && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get autoremove -y && apt-get autoclean -y; then
    echo "Error: Failed to update the system."
    return 1
  fi

  echo "Ubuntu/Debian system update complete."
  return 0
}

# Updating CentOS/RHEL/Fedora systems
function update_centos_rhel_fedora() {
  # Update package list, apply updates, and clean up package cache
  if ! yum update -y && yum clean all; then
    echo "Error: Failed to update the system."
    return 1
  fi

  echo "CentOS/RHEL/Fedora system update complete."
  return 0
}

# Detecting OS distribution and updating the system
function update_system() {
  # Detect the distribution type
  if [ -f /etc/os-release ]; then
    . /etc/os-release
  else
    echo "Error: Unable to detect distribution type."
    return 1
  fi

  if [[ "$ID" == "ubuntu" || "$ID" == "debian" ]]; then
    update_ubuntu_debian
  elif [[ "$ID" == "centos" || "$ID" == "rhel" || "$ID" == "fedora" ]]; then
    update_centos_rhel_fedora
  else
    echo "Error: Unsupported distribution type."
    return 1
  fi
}

# Call the update_system function
update_system