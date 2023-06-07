#!/bin/bash

# Function to adjust the SSH port
adjust_ssh_port() {
    read -p "Do you want to change the SSH port? (yes/no): " change_port

    if [ "$change_port" = "yes" ]; then
        read -p "Enter the new SSH port: " new_port

        # Check if the entered port is numeric
        if ! [[ "$new_port" =~ ^[0-9]+$ ]]; then
            echo "Error: Invalid port entered."
            exit 1
        fi

        # Neuer Text für den Ersatz
        new_port_text="Port $new_port"

    current_port=$(sudo grep -E "^#?Port [0-9]+" /etc/ssh/sshd_config)
    if [[ -n $current_port ]]; then
        # Port found, modify it
        sudo sed -i "s/$current_port/$new_port_text/g" /etc/ssh/sshd_config
        ./log.sh "SSH port has been modified to $new_port." 1
    else
        # Port not found, add it
        echo "Port 123" | sudo tee -a /etc/ssh/sshd_config > /dev/null
        ./log.sh "SSH port has been added as $new_port." 1
    fi
    ./log.sh "SSH-Port changed to $new_port" 1
        
    else
        ./log.sh "The SSH port will not be changed. May add or replace 'Port $new_port' to /etc/ssh/sshd_config" 1
    fi
}

# Function to set the allowed users for SSH access
set_allowed_users() {
    read -p "Enter a space-separated list of usernames that should have SSH access (leave blank for no restriction): " allowed_users

    if [ -z "$allowed_users" ]; then
        echo "There is no restriction on the allowed users."
    else
        # Modify SSH configuration
        sudo sed -i "/^AllowUsers/d" /etc/ssh/sshd_config
        sudo bash -c "echo \"AllowUsers $allowed_users\" >> /etc/ssh/sshd_config"
        ./log.sh "The following users have SSH access: $allowed_users" 1
    fi
}

# Main script
read -p "Do you want to adjust SSH settings? (yes/no): " adjust_ssh

if [ "$adjust_ssh" = "yes" ]; then
    adjust_ssh_port
    set_allowed_users
    echo "Restart SSH service."
    sudo service ssh restart
fi
