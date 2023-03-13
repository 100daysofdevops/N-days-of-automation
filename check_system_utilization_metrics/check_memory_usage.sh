#!/bin/bash
# Script to Calculate the memory utilization after subtracting the free, shared, and buffer cache memory from the total memory


# Set the memory average threshold
THRESHOLD=70

# Get the total available memory in the system
total_memory=$(awk '/MemTotal/ {print $2}' /proc/meminfo)
# Get free memory
free_memory=$(awk '/MemFree/  {print $2}' /proc/meminfo)
# Get shared memory
shared_memory=$(awk '/Shmem/  {print $2}' /proc/meminfo)
# Get buffer cache memory
buffer_cache_memory=$(awk '/Buffers/  {print $2}' /proc/meminfo)

# Check if the memory value is numeric
for val in $total_memory $free_memory $shared_memory $buffer_cache_memory; do
    if ! [[ $val =~ ^[0-9]+$ ]]; then
        echo "Error: Invalid memory value"
        exit 1
    fi
done

# Calculate memory utilization
used_memory=$((total_memory - free_memory - shared_memory - buffer_cache_memory))
memory_utilization=$((used_memory * 100 / total_memory))

# Check if mail command is installed
if ! type "mail" > /dev/null
then
    echo "mail command is not installed. Installing now..."
    sudo yum -y install mailx
else
    echo "mail command is already installed"
fi

# Check memory utilization against threshold
if [ $memory_utilization -gt $THRESHOLD ]
then
    echo "Memory utilization is above the threshold of $threshold%"
    
    # Send email alert
    email_subject="Memory utilization is above threshold"
    email_body="Memory utilization is currently at $memory_utilization%. Please check the server immediately."
    recipient_email="recipient@example.com"
    echo "$email_body" | mail -s "$email_subject" "$recipient_email"
else
    echo "Memory utilization is below the threshold of $threshold%"
fi