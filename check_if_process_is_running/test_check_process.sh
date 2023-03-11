# Test case 1
output=$(check_process nginx)
if [ "$output" = "Process 'nginx' is running." ]; then
  echo "Test case 1 passed"
else
  echo "Test case 1 failed"
fi
exit_code=$?
if [ "$exit_code" -eq 0 ]; then
  echo "Exit code 0 for Test case 1"
else
  echo "Exit code non-zero for Test case 1"
fi

# Test case 2
output=$(check_process fake_process_name)
if [ "$output" = "Process 'fake_process_name' is not running." ]; then
  echo "Test case 2 passed"
else
  echo "Test case 2 failed"
fi
exit_code=$?
if [ "$exit_code" -eq 1 ]; then
  echo "Exit code 1 for Test case 2"
else
  echo "Exit code non-zero for Test case 2"
fi

# Test case 3
output=$(check_process)
if [ "$output" = "Please provide the process name." ]; then
  echo "Test case 3 passed"
else
  echo "Test case 3 failed"
fi
exit_code=$?
if [ "$exit_code" -eq 1 ]; then
  echo "Exit code 1 for Test case 3"
else
  echo "Exit code non-zero for Test case 3"
fi
