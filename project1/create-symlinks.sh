
#!/bin/bash

# Creating necessary directories for linking.
mkdir -p ~/bin
mkdir -p ~/.config

# Creates links to make the files appear in those directories
ln -sf "$(pwd)/2420-as2-starting-files/bin" ~/bin
ln -sf "$(pwd)/2420-as2-starting-files/config" ~/.config
ln -sf "$(pwd)/2420-as2-starting-files/home/bashrc" ~/.bashrc
ln -sf "$(pwd)/2420-as2-starting-files/config/kak/kakrc" ~/.config/kak/kakrc
ln -sf "$(pwd)/2420-as2-starting-files/config/tmux/tmux.conf" ~/.config/tmux/tmux.conf

