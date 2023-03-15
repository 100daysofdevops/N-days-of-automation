#!/usr/bin/env bash

install_firewall_mailx() {
    # Create an array with a list of packages
    packages=("firewalld" "mailx")

    # Check if the following packages are installed
    for package in "${packages[@]}"; do
        if ! command -v "$package" >/dev/null 2>&1; then
            # If the package is not installed, install it
            if ! sudo yum -y install "$package" || ! sudo apt-get update && sudo apt-get -y install "$package"; then
                echo "Failed to install $package"
                exit 1
            fi
        fi
    done

    echo "All dependencies are installed now"
}

check_unauthenticated_attempt() {
    #Set the threshold for blocking IP addresses
    THRESHOLD=5

    #Get the current date and time
    current_date=$(date +"%Y-%m-%d %H:%M:%S")

    #Check /var/log/secure for any unauthenticated attempts
    unauthenticated_attempts=$(grep -c "Authentication failure" /var/log/secure | grep -v "invalid user")

    #If there is no authentication failure, exit the function
    if [[ $unauthenticated_attempts -eq 0 ]]; then
        return 0
    fi

    #Get the IP addresses of the failed attempts
    failed_ips=$(grep "authentication failure" /var/log/secure | grep -v "invalid user" | awk '{match($0, /[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+/, ip); print ip[0]}' | sort | uniq -c | awk '$1 >= '"$THRESHOLD"' {print $2}')

    #If there are no IP addresses that exceed the threshold, exit the function
    if [[ -z $failed_ips ]]; then
        return 0
    fi

    #Send an email notification with the number of unauthenticated attempts
    email_subject="Unauthenticated attempt detected on $(hostname) at $current_date"
    email_body="There were $unauthenticated_attempts unauthenticated attempts detected on $(hostname) at $current_date. The following IP addresses have exceeded the threshold: $failed_ips"
    recipient_email="recipient@mail.com"
    echo "$email_body" | mailx -s "$email_subject" "$recipient_email"

    #Block the SSH port for the IP addresses at firewalld
    for ip in $failed_ips; do
        if ! firewall-cmd --zone=public --query-rich-rule="rule family='ipv4' source address='$ip' service name='ssh' reject"; then
            if ! firewall-cmd --zone=public --add-rich-rule="rule family='ipv4' source address='$ip' service name='ssh' reject"; then
                echo "Failed to add firewall rule for IP address $ip"
                exit 1
            else
                echo "Added firewall rule to block SSH port for IP address $ip"
            fi
        else
            echo "Firewall rule for IP address $ip already exists"
        fi
    done

    #Reload the firewall rules
    if ! firewall-cmd --reload; then
        echo "Failed to reload firewall rules"
        exit 1
    else
        echo "Firewall rules reloaded"
    fi
}

# Call the functions
install_firewall_mailx
check_unauthenticated_attempt