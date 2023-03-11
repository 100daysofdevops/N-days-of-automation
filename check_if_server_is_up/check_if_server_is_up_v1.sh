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
read -p "Enter the hostname or IP address of the server: " server_name

# Call the function with the user input
check_server_up "$server_name"

# Safety check to check the return value of function
if [ $? -eq 0 ]
then
    echo "Server $server_name is up and running"
else
    echo "There is an error checking server $server_name " 
fi 