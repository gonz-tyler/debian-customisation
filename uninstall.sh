#!/bin/bash

echo "Uninstalling all packages installed by the script..."

# Define the list of packages to remove
declare -a packages=(
    "git" "curl" "wget" "vim" "build-essential" "unzip" "ripgrep" "fd-find"
    "emacs" "libgccjit-12-dev" "gcc" "zsh" "tmux"
    "make" "libssl-dev" "zlib1g-dev" "libbz2-dev"
    "libreadline-dev" "libsqlite3-dev" "llvm" "libncursesw5-dev"
    "xz-utils" "tk-dev" "libxml2-dev" "libxmlsec1-dev" "libffi-dev" "liblzma-dev"
    "autojump" "neofetch" "bat" "fd-find" "python3" "python3-pip" "python3-venv"
    "neovim" "code"
)

# Remove installed packages
for package in "${packages[@]}"; do
    echo "Removing $package..."
    sudo apt remove --purge -y "$package" >/dev/null 2>&1
done

# Remove lf file manager
echo "Removing lf file manager..."
sudo rm -f /usr/local/bin/lf

# Remove Doom Emacs
if [ -d "$HOME/.emacs.d" ]; then
    echo "Removing Doom Emacs..."
    rm -rf "$HOME/.emacs.d"
    rm -rf "$HOME/.doom.d"
    rm -rf "$HOME/.config/emacs"
fi

# Remove VS Code repository
echo "Removing VS Code repository..."
sudo rm -f /etc/apt/sources.list.d/vscode.list
sudo rm -f /usr/share/keyrings/packages.microsoft.gpg

# Remove Pyenv
if [ -d "$HOME/.pyenv" ]; then
    echo "Removing Pyenv..."
    rm -rf "$HOME/.pyenv"
fi

# Remove Autojump
echo "Removing Autojump..."
rm -rf "$HOME/.local/share/autojump"

# Restore original .bashrc
if [ -f "/etc/skel/.bashrc" ]; then
    echo "Restoring default .bashrc..."
    cp /etc/skel/.bashrc "$HOME/.bashrc"
fi

# Auto-remove leftover dependencies
echo "Cleaning up..."
sudo apt autoremove -y >/dev/null 2>&1
sudo apt clean >/dev/null 2>&1

echo "✅ Uninstallation complete! System is now clean."
