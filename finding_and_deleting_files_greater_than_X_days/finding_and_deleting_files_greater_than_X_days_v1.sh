#!/usr/bin/env bash

delete_old_files() {
  # Verify for required arguments
  if [ "$#" -ne 2 ]; then
    echo "Error: incorrect number of arguments"
    echo "Usage: $0 <directory_path> <days_old>"
    exit 1
  fi

  # Prompt user to enter directory and number of days from the command line arguments
  directory="$1"
  days="$2"

  # Verify that directory is not empty
  if [ -z "$directory" ]; then
    echo "Error: directory path cannot be empty"
    exit 1
  fi

  #find files older than specified number of days
  old_files=$(find "$directory" -type f -mtime +"$(( $days - 1 ))")

  if [ -z "$old_files" ]; then
    echo "No files older than $days days found in $directory"
    exit 0
  fi

  # Confirm with user before deleting the files
  echo "The following files are older than $days days:"
  echo "$old_files"
  read -p "Are you sure you want to delete these files? [y/N]: " confirm_delete

  if [ "$confirm_delete" = "y" ]; then
    # delete the files
    echo "$old_files" | xargs rm -vf

    # Notify users via email 
    echo "Old files successfully deleted" | mail -s "Old Files Deleted" recipient@example.com
  else
    echo "Aborting deletion of old files"
    exit 0
  fi
}

# Verifyrequired arguments
if [ "$#" -lt 2 ]; then
  echo "Error: insufficient arguments"
  echo "Usage: $0 <directory_path> <days_old>"
  exit 1
elif [ "$#" -gt 2 ]; then
  echo "Error: incorrect number of arguments"
  echo "Usage: $0 <directory_path> <days_old>"
  exit 1
fi

# Call the function with command line arguments directory and number of days
delete_old_files "$1" "$2"