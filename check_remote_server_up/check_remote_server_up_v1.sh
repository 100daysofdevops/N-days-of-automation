#!/usr/bin/env bash

set -euo pipefail

backup_to_remote_server() {
  if [[ $# -ne 3 ]]; then
    echo "Usage: $0  <directory_to_backup> <remote_server_user> <remote_server>"
    return 1
  fi

  local readonly DIRECTORY_TO_BACKUP="$1"
  local readonly REMOTE_SERVER_USER="$2"
  local readonly REMOTE_SERVER="$3"
  local readonly LOG_FILE="/var/log/backup.log"

  if ! command -v nc &>/dev/null; then
    if [[ -f /etc/redhat-release ]]; then
      if ! rpm -q nc &>/dev/null; then
        sudo yum -y install nc
      fi
    elif [[ -f /etc/lsb-release ]]; then
        sudo apt-get -y install netcat-openbsd
    else
      echo "Error: Unsupported operating system. Unable to install nc"
      return 1
    fi
  fi

  if ! nc -z -w 1 "${REMOTE_SERVER}" 22 &>/dev/null; then
    echo "Error: Remote Server ${REMOTE_SERVER} is not reachable"
    echo "$(date) Backup to Remote server ${REMOTE_SERVER} failed: server is not reachable" >>"$LOG_FILE"
    return 1
  fi

  if ! ssh "${REMOTE_SERVER_USER}@${REMOTE_SERVER}" "[ -d ${DIRECTORY_TO_BACKUP} ] && [ -r ${DIRECTORY_TO_BACKUP} ] && [ -w ${DIRECTORY_TO_BACKUP} ]" &>/dev/null; then
    echo "Error: Backup directory ${DIRECTORY_TO_BACKUP} does not exist or user ${REMOTE_SERVER_USER} does not have read/write permission"
    echo "$(date) Backup to Remote server ${REMOTE_SERVER} failed: backup directory ${DIRECTORY_TO_BACKUP} does not exist or user ${REMOTE_SERVER_USER} does not have permission" >>"$LOG_FILE"
    return 1
  fi

    # Take the backup using rsync command
    rsync -avz --delete --exclude '*.log' --exclude '*.tmp' ${DIRECTORY_TO_BACKUP}/ ${REMOTE_SERVER_USER}@${REMOTE_SERVER}:${DIRECTORY_TO_BACKUP}/

    # Verify if rsync command is successful
    if [ $? -ne 0 ]
    then
        echo "Error: There is an issue in performing backup to remote system using rsync"
    return 1
fi


  echo "Backup to ${REMOTE_SERVER}:${DIRECTORY_TO_BACKUP} completed successfully"
  return 0
}

if [[ $# -ne 3 ]]; then
  echo "Usage: $0  <directory_to_backup> <remote_server_user> <remote_server>"
  exit 1
fi

backup_to_remote_server "$@"