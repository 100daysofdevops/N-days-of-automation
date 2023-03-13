#!/usr/bin/env bash

RED_COLOR='\e[0;31m'
GRN_COLOR='\e[0;32m'
RST_COLOR='\e[0m'

# Function to check if file or directory exists
check_file_or_dir(){
    INPUT="${1}"
    if [ ! -e "$INPUT" ]; then
        OUTPUT="File or directory $INPUT not present"
    elif [ -d "$INPUT" ]; then
        OUTPUT="The entered input $INPUT is a directory"
        EXISTS=1
    elif [ -f "$INPUT" ]; then
        OUTPUT="The entered input $INPUT is a file"
        EXISTS=1
    else
        OUTPUT="The entered input $INPUT is neither a file nor a directory"
    fi

    # If file/dir not exists, don't check read permission
    if [[ ${EXISTS} -gt 0 ]]; then
        if [ ! -r "${1}" ]; then
            OUTPUT+="; You don't have permission to read ${1}"
        fi
    fi
    echo "$OUTPUT"
    return 0
}

# Set test report function
test_report() {
    OUTPUT=$(check_file_or_dir "${1}")
    EXPECTED="${2}"
    if [[ "$OUTPUT" != "$EXPECTED" ]]; then
        printf "%b Test failed: expected '%s' but got '%s'%b\n" \
               "${RED_COLOR}" "${EXPECTED}" "${OUTPUT}" "${RST_COLOR}"
        return 1
    else
        printf '%bTest passed%b\n' "${GRN_COLOR}" "${RST_COLOR}"
        return 0
    fi
}

# Set tests
test1() {
    EXPECTED="The entered input test.txt is a file"
    INPUT="test.txt"
    test_report "${INPUT}" "${EXPECTED}"
}

test2() {
    EXPECTED="The entered input /proc/1 is a directory"
    INPUT="/proc/1"
    test_report "${INPUT}" "${EXPECTED}"
}

test3() {
    EXPECTED="The entered input /etc/shadow is a file"
    EXPECTED+="; You don't have permission to read /etc/shadow"
    INPUT="/etc/shadow"
    test_report "${INPUT}" "${EXPECTED}"
}

test4() {
    EXPECTED="File or directory xyz.txt not present"
    INPUT="xyz.txt"
    test_report "${INPUT}" "${EXPECTED}"
}

# Declare tests array
TESTS=( test1
        test2
        test3
        test4 )

# Run the tests
for TEST in ${TESTS[@]}; do
    $TEST
    TEST_RESULTS+="$?"
done

# Check the exit codes of the tests
if [[ ${TEST_RESULTS[@]} =~ 1 ]]; then
    echo "Some tests failed"
else
    echo "All tests passed"
fi
