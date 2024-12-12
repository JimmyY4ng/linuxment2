# linuxment0

setup-user.sh:
```
#!/bin/bash
# Check if script is run as root
if [[ "$(id -u)" -ne 0 ]]; then
   echo "Please run this script with sudo or as root."
   exit 1
fi
# Initialize variables
username=""
shell="/bin/bash"  # Default shell if none provided
groups=""
# Use getopts for user input
while getopts "u:s:g:" opt; do
  case $opt in
    u) username="$OPTARG" ;;  # Username
    s) shell="$OPTARG" ;;     # Shell
    g) groups="$OPTARG" ;;    # Additional groups (comma-separated)
    \?) echo "Invalid option: -$OPTARG" >&2; exit 1 ;;
  esac
done
# Ensure the username is provided
if [[ -z "$username" ]]; then
  echo "Username is required. Use -u to specify it."
  exit 1
fi
# Define the home directory
home_dir="/home/$username"
# Generate a unique user ID by finding the maximum user ID in use and adding 1
user_id=$(awk -F: '($3>=1000)&&($3<60000){if($3>max) max=$3} END{print max+1}' /etc/passwd)
group_id=$(grep "^$username:" /etc/group | awk -F: '{print $3}' || echo "$user_id") # Finds the line in /etc/group where the group name matches $username and prints the third field, the group ID
# Append the new user details to /etc/passwd using heredoc
cat >> /etc/passwd <<- EOF
$username:x:$user_id:$group_id:$username:$home_dir:$shell
EOF
# Add additional groups
# Append group info to /etc/group using group name, ID, and username
IFS=',' read -r -a group_array <<< "$groups"
for group in "${group_array[@]}"; do
  cat >> /etc/group <<- EOF
$group:x:$(grep "^$group:" /etc/group | awk -F: '{print $3}'):$username 
EOF
done
# Ensure the user’s home directory exists
mkdir -p "$home_dir" 
cp -r /etc/skel/. "$home_dir" # copy contents of /etc/skel into home directory
chown -R "$username:$username" "$home_dir" # Set the ownership of the home directory and its contents to the new user
# Output success message
echo "User $username created successfully with the following settings:"
echo "Shell: $shell"
echo "Home directory: $home_dir"
echo "Primary group: $username"
echo "Additional groups: $groups"
```
Uses getopts to capture the username, shell, and groups, giving flexibility for different user needs. It dynamically generates a unique user ID based on the highest existing ID in /etc/passwd to avoid conflicts. Additional groups are managed through IFS to splitcommas, and awk finds or assigns group IDs, ensuring accurate group setup for each new user.

create-symlinks.sh:
```
#/bin/bash
while getopts "d:" opt; do
  case $opt in
    # If the option is -d, set 'target_dir' to the specified argument
    d) target_dir=$OPTARG ;;
    # If an invalid option is given, print usage information and exit
    *) echo "Usage: $0 [-d target_directory]"; exit 1 ;;
  # Close the case statement
  esac
# Close the while loop
done
# Set 'target_dir' to $HOME if it wasn’t provided by the user
target_dir=${target_dir:-$HOME}
# Create a symbolic link for the 'bin' directory within '2420-as2-starting-files' to the target directory's bin
ln -sf "$(pwd)/2420-as2-starting-files/bin" "$target_dir/bin"
# Create a symbolic link for the 'config' directory within '2420-as2-starting-files' to the target directory's .config
ln -sf "$(pwd)/2420-as2-starting-files/config" "$target_dir/.config"
# Create a symbolic link for the 'bashrc' file within '2420-as2-starting-files/home' to the target directory's .bashrc
ln -sf "$(pwd)/2420-as2-starting-files/home/bashrc" "$target_dir/.bashrc"
```

Uses ln -sf commands to create symbolic links, making files appear in new locations without actually moving them. The getopts function allows for a user-specified target directory using the -d option, defaulting to $HOME if unspecified, enhancing flexibility by dynamically changing the destination of the links.

create_ex_config_files.sh:

```
git clone https://gitlab.com/cit2420/2420-as2-starting-files.git
```
Uses git clone to bring in pre-defined configuration files. Cloning within the script ensures that users have the latest versions of the configurations without needing to download them manually.

install-packages.sh:
```
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
```
Reads package-list.txt line by line, ensuring each package listed is installed through a while loop. The script validates that it’s run with root permissions, which is necessary for package installation, and handles cases where package-list.txt is missing, adding robustness.

package-list.txt:
```
kakoune
tmux
```
This file serves as the user-defined list for install-packages.sh, storing package names in plain text, one per line. This format ensures compatibility with while read -r and maintains simplicity for easy editing.

setup.sh
```
# Run symbolic link script
./create-symlinks.sh
./install-packages.sh
# Run to git clone provided example configuration files
./create_ex_config_files.sh

```
Sequentially executes every script in directory project1



example commit
