# Remote Backup Script
This script is used to backup a local directory to a remote server using rsync.


## Prerequisites
This script requires the following:

```
Bash
rsync
nc or netcat-openbsd
SSH access to the remote server
Setup password less authentication between two servers
```

## Usage
```
./check_remote_server_up_v1.sh <directory_to_backup> <remote_server_user> <remote_server>

./check_remote_server_up_v1.sh /path/to/local/directory myuser example.com


```
## Contributing
Contributions are welcome! If you find any issues or have any suggestions for improvements, please submit an issue or pull request on GitHub.