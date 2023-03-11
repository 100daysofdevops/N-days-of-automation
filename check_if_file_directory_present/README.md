# Check if File or Directory is Present

A simple Bash script to check if a file or directory exists, and whether it is a file or directory. The script also handles errors if the file or directory does not exist or if the user does not have permission to access it..

## Getting Started
To use the script, simply clone or download the repository. 
```
git clone git@github.com:100daysofdevops/N-days-of-automation.git
```

You can then run the script by executing the following command:

```
bash check_if_file_directory_present_2.sh
```


## Prerequisites
The script requires Bash to be installed on your Linux system.

## Usage
To use the script, simply run the command :

```
bash check_if_file_directory_present_2.sh
```

## Shell script one liner
```
[ -e "$path" ] && [ -f "$path" ] && echo "$path is a file." || [ -d "$path" ] && echo "$path is a directory." || echo "$path does not exist."
```

## Contributing
Contributions to this script are welcome. If you find any bugs or have suggestions for improvement, feel free to open an issue or submit a pull request.
