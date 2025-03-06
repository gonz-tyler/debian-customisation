#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Install Emacs if not installed
if ! command_exists emacs; then
    echo "Installing Emacs..."
    sudo apt update && sudo apt install -y emacs
else
    echo "Emacs is already installed. Skipping..."
fi

# Clone Doom Emacs if not already installed
if [ ! -d "$HOME/.config/emacs" ]; then
    echo "Cloning Doom Emacs..."
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
else
    echo "Doom Emacs is already installed. Skipping cloning..."
fi

# Run Doom install
~/.config/emacs/bin/doom install

# Add Doom Emacs to PATH if not already added
if ! grep -q 'export PATH="$HOME/.config/emacs/bin:$PATH"' ~/.bashrc; then
    echo "Adding Doom Emacs to PATH..."
    echo 'export PATH="$HOME/.config/emacs/bin:$PATH"' >> ~/.bashrc
    source ~/.bashrc
else
    echo "Doom Emacs is already in PATH. Skipping..."
fi

# Run Doom sync
doom sync

# Add aliases if not already added
if ! grep -q "alias notes=\"emacsclient -c -a 'emacs' &\"" ~/.bashrc; then
    echo "Adding aliases..."
    echo 'alias notes="emacsclient -c -a 'emacs' &"' >> ~/.bashrc
    echo 'alias emacs="emacsclient -c -a 'emacs' &"' >> ~/.bashrc
else
    echo "Aliases already exist. Skipping..."
fi

echo "Doom Emacs installation and setup complete!"
