
#!/bin/bash


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

