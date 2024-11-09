#!/bin/bash
# Run package installation script
./install-packages.sh

# Run symbolic link script
./create-symlinks.sh

# Run to git clone provided example configuration files
./create_ex_config_files.sh
