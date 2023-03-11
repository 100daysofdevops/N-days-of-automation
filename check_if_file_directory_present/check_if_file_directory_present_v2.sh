#!/bin/bash

check_file_or_dir(){
    if [ ! -e  "$1" ]
    then
        echo "File or directory $1 not present"
        return 1
    fi

    if [ -d "$1" ]
    then
        echo "The entered input $1 is a directory"
    elif [ -f "$1" ]
    then
        echo "The entered input $1 is a file"
    else
        echo "The entered input $1 is neither a file nor a directory"
    return 2
    fi  

    if [ -r "$1" ]
    then
        echo "You don't have a permission to read $1"
        return 3
    fi    
}

# Ask user for the input
read -p "Enter the name of file or directory: " input_file_or_dir

# Call the function with the user input
check_file_or_dir "$input_file_or_dir"

# Safety check to check the return value of function
if [ $? -eq 0 ]
then
    echo "File or directory $input_file_or_dir exists"
else
    echo "There is an error checking $input_file_or_dir" 
fi       