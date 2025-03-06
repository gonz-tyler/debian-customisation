#!/bin/bash

# Define variables
INSTALL_DIR="$(pwd)"  # Assumes script is run from cloned repo directory
BASHRC_PATH="$INSTALL_DIR/bashrc.txt"  # The provided .bashrc file
TARGET_BASHRC="$HOME/.bashrc"

# Update and install required packages
echo "Updating package list and upgrading system..."
sudo apt update && sudo apt upgrade -y

echo "Installing required packages..."
sudo apt install -y git curl wget vim build-essential unzip ripgrep fd-find \
    emacs libgccjit-12-dev gcc zsh tmux \
    make build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev \
    xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev \
    autojump neofetch bat fd-find python3 python3-pip python3-venv

# Install Neovim
echo "Installing Neovim..."
sudo apt install -y neovim

# Install lf (lightweight file manager)
echo "Installing lf file manager..."
curl -fsSL https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz | tar xz
sudo mv lf /usr/local/bin/

# Install VS Code
echo "Installing VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
sudo apt update && sudo apt install -y code
rm -f packages.microsoft.gpg

# Install Doom Emacs
if [ ! -d "$HOME/.emacs.d" ]; then
    echo "Installing Doom Emacs..."
    git clone --depth 1 https://github.com/hlissner/doom-emacs.git ~/.emacs.d
    ~/.emacs.d/bin/doom install
else
    echo "Doom Emacs is already installed."
fi

# Install Pyenv (Python version manager) but don't install Python with it
if [ ! -d "$HOME/.pyenv" ]; then
    echo "Installing pyenv..."
    curl https://pyenv.run | bash

    # Ensure pyenv is set up in the bashrc file
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME/.bashrc"
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'eval "$(pyenv init --path)"' >> "$HOME/.bashrc"
else
    echo "Pyenv is already installed."
fi

# Copy the custom .bashrc file from the repo
if [ -f "$BASHRC_PATH" ]; then
    echo "Applying custom .bashrc..."
    cp "$BASHRC_PATH" "$TARGET_BASHRC"

    # Reload bashrc
    echo "Reloading .bashrc..."
    source "$TARGET_BASHRC"
else
    echo "Error: .bashrc file not found in the repository!"
    exit 1
fi

echo "Setup completed successfully!"
