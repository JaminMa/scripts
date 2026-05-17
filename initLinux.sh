#!/bin/bash

# .bashrc
echo "Creating/appending .bashrc..."
sed -i '/# BEGIN OF https:\/\/raw.githubusercontent.com\/JaminMa\/dotfiles\/master\/.bashrc/,/# END OF https:\/\/raw.githubusercontent.com\/JaminMa\/dotfiles\/master\/.bashrc/d' ~/.bashrc
curl -LSs https://raw.githubusercontent.com/JaminMa/dotfiles/master/.bashrc >> ~/.bashrc

# ------

# NVM
echo "Installing Node Version Manager..."
curl -LSs https://raw.githubusercontent.com/nvm-sh/nvm/refs/heads/master/install.sh | bash > /dev/null

# ------

# VIM
echo "Checking for VIM installation..."
if ! command -v vim &> /dev/null; then
    echo "VIM not found, installing..."
    # Check package manager and install VIM
    if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y vim || { echo "VIM installation failed!"; exit 1; }
    elif command -v dnf &> /dev/null; then
        sudo dnf install -y vim || { echo "VIM installation failed!"; exit 1; }
    elif command -v brew &> /dev/null; then
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Please install it first."
            exit 1
        fi
        brew install vim || { echo "VIM installation failed!"; exit 1; }
    else
        echo "Package manager not found. Please install VIM manually."
        exit 1
    fi
else
    echo "VIM is already installed."
fi

echo "Configuring VIM and installing Pathogen, Syntastic, and Monokai color theme..."
rm -rf ~/.vimrc && curl -LSs https://raw.githubusercontent.com/JaminMa/dotfiles/master/.vimrc > ~/.vimrc
rm -rf ~/.vim
mkdir -p ~/.vim/autoload ~/.vim/bundle && curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
cd ~/.vim/bundle && git clone --quiet --depth=1 https://github.com/vim-syntastic/syntastic.git > /dev/null
mkdir -p ~/.vim/colors && curl -LSso ~/.vim/colors/monokai.vim https://raw.githubusercontent.com/sickill/vim-monokai/master/colors/monokai.vim

# ------

# Git
echo "Configuring Git..."
rm -rf ~/.gitconfig && curl -LSs https://raw.githubusercontent.com/JaminMa/dotfiles/master/.gitconfig > ~/.gitconfig
read -p "Please enter your full name for Git config: " gitFullName
git config --global user.name "$gitFullName"
read -p "Please enter your email for Git config: " email
git config --global user.email "$email"

# ------

# SSH Key
while true; do
  read -p "Generate SSH key? (Y/n) " yn
  case $yn in
    [Yy]*|"")
      ssh-keygen
      echo "Remember to upload the new token to your GitHub account."
      break;;
    [Nn]*)
      echo "Skipping SSH key generation."
      break;;
    *)
      echo "Please enter yes or no.";;
  esac
done

# End Script
echo "Script completed!"
