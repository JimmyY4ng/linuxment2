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

