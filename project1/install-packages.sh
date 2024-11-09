#!/bin/bash

# Ensure if script is run with sudo or as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root."
    exit 1
fi

# Define the path to the user-defined list of packages
package_file="package-list.txt"

# Check if the package list file exists
if [[ ! -f $package_file ]]; then
    echo "Package list file '$package_file' not found!"
    exit 1
fi

# Install each package from the package file
while read -r package; do             # Reads each line from the package list file
    if [[ -n $package ]]; then         # Checks if the line is not empty
        pacman -S --noconfirm "$package"  # Installs the package using pacman without confirmation
    fi
done < "$package_file"                  # Redirects the content of package_file into the while loop

echo "All packages installed successfully."
