#!/bin/bash

function check_port {
    # Check if the port number was provided
    if [ -z "$1" ]; then
        echo "Please provide the port number."
        exit 1
    fi

    # Check if port is up or not
    if ! ss -nptl | grep $1 > /dev/null;  then
        echo "Port '$1' is not up."
    else
        echo "Port '$1' is up."
    fi
}

check_port "$1"
