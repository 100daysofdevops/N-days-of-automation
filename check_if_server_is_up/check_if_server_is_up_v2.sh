#!/bin/bash

check_server_up(){
# Perform ping 5 time to check if server is up
if ping -c 5 "$1" > /dev/null 2>&1
then
    echo "Server $1 is up and running"
    return 0
else
    echo "Server $1 is down or unreachable"
    return 1
fi        
}

# Prompt user to enter server name as input
read -p "Enter the name of the file containing server name: " server_name_file

# Check if the file exists

if [ ! -f "$server_name_file" ]
then 
    echo "File $server_name_file not found"
    exit 1
fi

# Read each server name from the file and verify there status

while read -r server_name
do
    check_server_up "$server_name"
    if [ $? -eq 0 ]
    then
        echo "Server $server_name is up and running"
    else
        echo "There is an error checking server $server_name " 
    fi
done < "$server_name_file"