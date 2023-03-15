# SSH Authentication Failure Blocker

This script monitors the /var/log/secure log file for any SSH authentication failures, and blocks the SSH port for IP addresses that exceed a specified threshold.


## Installation

To use the script, you must have the firewalld and mailx packages installed. You can install them using the following commands or script will take care of it:

```bash
sudo yum -y install firewalld mailx   # For CentOS, RHEL, or Fedora
sudo apt-get update && sudo apt-get -y install firewalld mailx   # For Debian or Ubuntu

```

## Usage

```
bash ssh_authentication_failure_block_v1.sh
```

## Customization
You can customize the script by modifying the following variables at the top of the script:

```THRESHOLD:``` The number of authentication failures from a single IP address that triggers the blocking of the SSH port. Default is 5.

```recipient_email:``` The email address where the notification email will be sent. Default is recipient@mail.com.

You can also modify the firewall-cmd command in the check_unauthenticated_attempt function to block other ports or protocols as needed.

## Troubleshooting
If you're having issues with the script, you can check the log file /var/log/secure for any errors or warnings related to the script. You can also check the firewalld logs for any errors related to the firewall rules.

To check the firewall rules, you can use the following command:

```
sudo firewall-cmd --zone=public --list-all
```
This will display a list of all the rules in the public zone, including any rules added by the script to block IP addresses or the SSH port.

## Contributing

Contributions are welcome! If you find any issues or have any suggestions for improvements, please submit an issue or pull request on GitHub.
