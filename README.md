# Debian Customisation

## Auto Setup Script for Debian-Based Systems

This script automates the installation of essential tools and configuration for a Debian-based system. It installs various software, sets up a custom .bashrc, and ensures a streamlined developer environment.

## Features

✅ Installs essential software: git, vim, neovim, emacs, doom emacs, VS Code, lf, tmux, zsh, etc.

✅ Sets up pyenv for Python version management

✅ Enables automatic activation of Python virtual environments when navigating directories

✅ Configures terminal with a custom .bashrc from the repository

✅ Includes quality-of-life improvements: bat, autojump, fd-find, neofetch, etc.

✅ Uses a clean installation process with a progress indicator

## Installation

### 1. Install Git and Clone the Repository

If you haven't installed Git yet, install it first:

```bash
sudo apt install git -y
```

Then, clone this repository:
```bash
git clone https://github.com/gonz-tyler/debian-customisation.git && cd debian-customisation
```
### 2. Run the Installation Script

Make the script executable:
```bash
chmod +x install.sh
```
Run the script:
```bash
./install.sh
```
## Uninstallation

To remove everything installed by this script, run the uninstall.sh script:
```bash
chmod +x uninstall.sh
./uninstall.sh
```
This will:

- Remove installed packages

- Delete Doom Emacs, Pyenv, and other configurations

- Restore the default .bashrc

## Manual Virtual Environment Management

#### 1. Create a virtual environment:
```bash
python3 -m venv .venv
```
#### 2. Navigate to the directory and it will auto-activate!
```bash
cd my_project  # .venv activates automatically
```
#### 3. Deactivate when leaving the directory:
```bash
cd ~  # .venv deactivates automatically
```
## Custom `.bashrc`

The script replaces the default .bashrc with a custom version that:

- Includes helpful aliases

- Configures neovim and doom emacs

- Uses starship for a modern terminal prompt

- Enables lf icons and autojump support

## Notes

- This script is designed for Debian-based systems (Ubuntu, Pop!_OS, etc.)

- Ensure you have `sudo` privileges before running it

- You can modify the `.bashrc` file in the repo before installation to customize it further

## Future Improvements

- Automate installation of zsh-autosuggestions when zsh shell is picked

- Improve logo ascii art

## Contributing

Feel free to open an issue or submit a pull request for improvements!

## License

This project is licensed under the MIT License.
