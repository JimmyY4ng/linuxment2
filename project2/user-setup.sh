
#!/bin/bash

# Check if script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
   echo "Please run this script with sudo or as root."
   exit 1
fi

# Get input for username, shell, and additional groups
read -p "Enter new username: " username
read -p "Enter the default shell for the user (e.g., /bin/bash): " shell
read -p "Enter additional groups (comma-separated, or leave blank for none): " groups




