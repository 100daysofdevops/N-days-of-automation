# Memory Utilization Check Shell Script

This shell script calculates the memory utilization of a Linux system by subtracting the free, shared, and buffer cache memory from the total memory. If the memory utilization exceeds the threshold (default: 70%), the script will also send an email alert to the specified recipient.

## Requirements

```
1. Bash shell
2. mail command (for email alerts)
```

## Usage

```
bash check_memory_usage.sh

```

## Contributing

Contributions are welcome! If you find any issues or have any suggestions for improvements, please submit an issue or pull request on GitHub.

