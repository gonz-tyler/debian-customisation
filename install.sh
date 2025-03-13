#!/bin/bash

# Define variables
INSTALL_DIR="$(pwd)"  # Assumes script is run from cloned repo directory
BASHRC_PATH="$INSTALL_DIR/.bashrc"
ZSHRC_PATH="$INSTALL_DIR/.zshrc"

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to show a progress indicator while a command runs
show_progress() {
    local pid=$!
    local delay=0.2
    local spin='-\|/'

    while ps -p $pid &>/dev/null; do
        for i in {0..3}; do
            echo -ne "\r${spin:i:1} Installing $1..."
            sleep $delay
        done
    done
    wait $pid # Capture exit status
    if [ $? -eq 0 ]; then
        echo -e "\r✔ $1 installed successfully!            "
    else
        echo -e "\r✖ Error installing $1. Check logs.      "
    fi
}

# Clear the screen
clear

# Define colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Display custom ASCII art for DedSoc
echo -e "${CYAN}"
echo "░▒▓███████▓▒░░▒▓████████▓▒░▒▓███████▓▒░ ░▒▓███████▓▒░░▒▓██████▓▒░ ░▒▓██████▓▒░       "
echo "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      "
echo "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             "
echo "░▒▓█▓▒░░▒▓█▓▒░▒▓██████▓▒░ ░▒▓█▓▒░░▒▓█▓▒░░▒▓██████▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             "
echo "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░             "
echo "░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░      "
echo "░▒▓███████▓▒░░▒▓████████▓▒░▒▓███████▓▒░░▒▓███████▓▒░ ░▒▓██████▓▒░ ░▒▓██████▓▒░       "
echo -e "${NC}"
echo -e "${PURPLE}===========================================${NC}"
echo -e "${YELLOW}Welcome to ${RED}DedSoc${YELLOW} Custom Debian Installer${NC}"
echo -e "${GREEN}Your system, your rules! Let's make it awesome.${NC}"
echo -e "${PURPLE}===========================================${NC}"

# Ask the user if they want to start
while true; do
    echo -e "${BLUE}Do you want to start the installation? (y/n)${NC}"
    read -r yn
    case $yn in
        [Yy]* )
            echo -e "${GREEN}Starting DedSoc installation...${NC}"

            # Ask the user if they want to use bash or zsh
            while true; do
                echo -e "${BLUE}Which shell do you want to use? (bash/zsh)${NC}"
                read -r shell_choice
                case $shell_choice in
                    [Bb]* )
                        echo -e "${GREEN}Setting bash as the default shell...${NC}"
                        # Ensure bash is installed
                        if ! command -v bash &> /dev/null; then
                            echo -e "${YELLOW}Bash is not installed. Installing bash...${NC}"
                            sudo apt-get update && sudo apt-get install -y bash
                        fi
                        # Set bash as the default shell
                        chsh -s /bin/bash
                        echo -e "${GREEN}Bash is now the default shell.${NC}"
                        TARGET_RC="$HOME/.bashrc"
                        RC_PATH="$BASHRC_PATH"
                        break
                        ;;
                    [Zz]* )
                        echo -e "${GREEN}Setting zsh as the default shell...${NC}"
                        # Ensure zsh is installed
                        if ! command -v zsh &> /dev/null; then
                            echo -e "${YELLOW}Zsh is not installed. Installing zsh...${NC}"
                            sudo apt-get update && sudo apt-get install -y zsh
                            echo -e "${Green}Installing Oh-My-Zsh...${NC}"
                            sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
                            echo -e "${Green}Installing Plugins...${NC}"
                            git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
                            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
                        fi
                        # Set zsh as the default shell
                        chsh -s /bin/zsh
                        echo -e "${GREEN}Zsh is now the default shell.${NC}"
                        TARGET_RC="$HOME/.zshrc"
                        RC_PATH="$ZSHRC_PATH"
                        break
                        ;;
                    * )
                        echo -e "${RED}Please answer with 'bash' or 'zsh'.${NC}"
                        ;;
                esac
            done

            break
            ;;
        [Nn]* )
            echo -e "${RED}Installation cancelled. Exiting...${NC}"
            exit 0
            ;;
        * )
            echo -e "${RED}Please answer with 'y' or 'n'.${NC}"
            ;;
    esac
done

echo "Installing Software Properties Common..."
sudo apt-get install software-properties-common >/dev/null 2>&1 &
show_progress "SPC"
echo "Adding necessary PPAs..."
sudo add-apt-repository ppa:zhangsongcui3371/fastfetch >/dev/null 2>&1 &
show_progress "PPAs"

# Update package list
echo "Updating package list..."
sudo apt update >/dev/null 2>&1 &
show_progress "System Update"

# Upgrade packages
echo "Upgrading packages..."
sudo apt upgrade -y >/dev/null 2>&1 &
show_progress "System Upgrade"

# Install required packages
declare -a packages=(
    "git" "curl" "wget" "vim" "build-essential" "unzip" "ripgrep" "fd-find"
    "libgccjit-12-dev" "gcc" "zsh" "tmux"
    "make" "libssl-dev" "zlib1g-dev" "libbz2-dev"
    "libreadline-dev" "libsqlite3-dev" "llvm" "libncursesw5-dev"
    "xz-utils" "tk-dev" "libxml2-dev" "libxmlsec1-dev" "libffi-dev" "liblzma-dev"
    "autojump" "fastfetch" "bat" "fd-find" "python3" "python3-pip" "python3-venv"
)

for package in "${packages[@]}"; do
    sudo apt install -y "$package" >/dev/null 2>&1 &
    show_progress "$package"
done

# Install Neovim
echo "Installing Neovim..."
sudo apt install -y neovim >/dev/null 2>&1 &
show_progress "Neovim"

# Install lf (file manager)
echo "Installing lf file manager..."
curl -fsSL https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz | tar xz >/dev/null 2>&1 &
show_progress "lf"
sudo mv lf /usr/local/bin/ >/dev/null 2>&1

# Install VS Code
# echo "Installing VS Code..."
# wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
# sudo install -o root -g root -m 644 packages.microsoft.gpg /usr/share/keyrings/ >/dev/null 2>&1
# echo "deb [arch=amd64 signed-by=/usr/share/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
# sudo apt update >/dev/null 2>&1 &
# show_progress "VS Code"
# sudo apt install -y code >/dev/null 2>&1 &
# show_progress "VS Code"

# rm -f packages.microsoft.gpg

# Install Doom Emacs using the previous script logic
if ! command_exists emacs; then
    echo "Installing Emacs..."
    sudo apt install -y emacs
else
    echo "Emacs is already installed. Skipping..."
fi

if [ ! -d "$HOME/.config/emacs" ]; then
    echo "Cloning Doom Emacs..."
    git clone --depth 1 https://github.com/doomemacs/doomemacs $HOME/.config/emacs
else
    echo "Doom Emacs is already installed. Skipping cloning..."
fi

yes | $HOME/.config/emacs/bin/doom install >/dev/null 2>&1 &
show_progress "doomemacs"

if ! grep -q 'export PATH="$HOME/.config/emacs/bin:$PATH"' $HOME/.bashrc; then
    echo "Adding Doom Emacs to PATH..."
    echo 'export PATH="$HOME/.config/emacs/bin:$PATH"' >> $HOME/.bashrc
    source $HOME/.bashrc
else
    echo "Doom Emacs is already in PATH. Skipping..."
fi

doom sync >/dev/null 2>&1 &
show_progress "doom sync"

if ! grep -q "alias notes=\"emacsclient -c -a 'emacs' &\"" $HOME/.bashrc; then
    echo "Adding aliases..."
    echo 'alias notes="emacsclient -c -a 'emacs' &"' >> $HOME/.bashrc
    echo 'alias emacs="emacsclient -c -a 'emacs' &"' >> $HOME/.bashrc
else
    echo "Aliases already exist. Skipping..."
fi

echo "Doom Emacs installation and setup complete!"

# Enable Emacs as a systemd user service
# systemctl --user enable --now emacs

# Install Pyenv (Python version manager) but don’t install Python with it
if [ ! -d "$HOME/.pyenv" ]; then
    echo "Installing pyenv..."
    curl https://pyenv.run | bash >/dev/null 2>&1 &
    show_progress "Pyenv"

    # Ensure pyenv is set up in .bashrc
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> "$HOME/.bashrc"
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> "$HOME/.bashrc"
    echo 'eval "$(pyenv init --path)"' >> "$HOME/.bashrc"
else
    echo "✔ Pyenv is already installed."
fi

# Copy the custom configuration file from the repo
if [ -f "$RC_PATH" ]; then
    echo "Applying custom $TARGET_RC..."
    cp "$RC_PATH" "$TARGET_RC"
    echo "✔ $TARGET_RC applied!"

    # Reload the configuration file
    if [[ "$SHELL_TYPE" == "bash" ]]; then
        source "$TARGET_RC"
    elif [[ "$SHELL_TYPE" == "zsh" ]]; then
        source "$TARGET_RC"
    fi
else
    echo "✖ Error: $RC_PATH file not found in the repository!"
    exit 1
fi

echo "🎉 Setup completed successfully!"
