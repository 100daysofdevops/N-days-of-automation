#!/bin/bash

check_server_up(){
# Perform a check to see if the server is reachable on the specified port
if nc -z -w1 "$1" "$2" >/dev/null 2>&1
then
    echo "Server $1 is up and running"
    return 0
else
    echo "Server $1 is down or unreachable"
    return 1
fi        
}

# Prompt user to enter server name and port as input
read -p "Enter the name of the file containing server name and port: " server_info_file

# Check if the file exists

if [ ! -f "$server_info_file" ]
then 
    echo "File $server_info_file not found"
    exit 1
fi

# Read each server name and port from the file and verify their status

while read -r server_name server_port
do
    check_server_up "$server_name" "$server_port"
    if [ $? -eq 0 ]
    then
        echo "Server $server_name is up and running"
    else
        echo "There is an error checking server $server_name " 
    fi
done < "$server_info_file"
