#!/bin/bash

# Copy the check_file_or_dir function from the script
check_file_or_dir(){
    local input=$1
    local output=""

    if [ ! -e "$input" ]
    then
        output="File or directory $input not present"
    elif [ -d "$input" ]
    then
        output="The entered input $input is a directory"
    elif [ -f "$input" ]
    then
        output="The entered input $input is a file"
    else
        output="The entered input $input is neither a file nor a directory"
    fi

    if [ ! -r "$input" ]
    then
        output+="; You don't have permission to read $input"
    fi

    echo "$output"
    return 0
}


# Run the Test that the function correctly identifies files and directories
test1() {
    expected="The entered input test.txt is a file"
    input="test.txt"

    output=$(check_file_or_dir "$input")

    if [ "$output" != "$expected" ]; then
        echo -e "\033[0;31mTest failed: expected '$expected' but got '$output'\033[0m"
        return 1
    else
        echo -e "\033[0;32mTest passed\033[0m"
        return 0
    fi
}

test2() {
    expected="The entered input /proc/1 is a directory"
    input="/proc/1"

    output=$(check_file_or_dir "$input")

    if [ "$output" != "$expected" ]; then
        echo -e "\033[0;31mTest failed: expected '$expected' but got '$output'\033[0m"
        return 1
    else
        echo -e "\033[0;32mTest passed\033[0m"
        return 0
    fi
}

test3() {
    expected="You don't have permission to read /etc/shadow"
    input="/etc/shadow"

    output=$(check_file_or_dir "$input")

    if [ "$output" != "$expected" ]; then
        echo -e "\033[0;31mTest failed: expected '$expected' but got '$output'\033[0m"
        return 1
    else
        echo -e "\033[0;32mTest passed\033[0m"
        return 0
    fi
}

test4() {
    expected="File or directory xyz.txt not present"
    input="xyz.txt"

    output=$(check_file_or_dir "$input")

    if [ "$output" != "$expected" ]; then
        echo -e "\033[0;31mTest failed: expected '$expected' but got '$output'\033[0m"
        return 1
    else
        echo -e "\033[0;32mTest passed\033[0m"
        return 0
    fi
}

# Run the tests
test1
test2
test3
test4

# Check the exit codes of the tests
if [ "$?" -eq 0 ]; then
    echo "All tests passed"
else
    echo "Some tests failed"
fi
