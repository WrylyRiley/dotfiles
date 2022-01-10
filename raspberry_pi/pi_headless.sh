#!/bin/bash

#####################################################################
####   Tooling   ####################################################
#####################################################################
sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y

sudo apt install git -y
sudo apt install zsh -y
sudo chsh -s $(which zsh)

#####################################################################
####   oh-my-zsh, plugins, zsh settings   ###########################
#####################################################################

echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "Installing bullet-train"
curl -L -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme

echo "Installing zsh-syntax-highlighting"
git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

echo "Copying config files for zsh"
cp ~/.zshrc ~/.zshrc.old
cp ./.zshrc_pi ~/.zshrc
touch ~/.zshenv
echo "source ~/.zshrc" >>~/.zshenv

#####################################################################
####   Git Preferences   ############################################
#####################################################################
git config --global user.name "Riley Bauer"
git config --global user.email "wryr1ley@gmail.com"
git config --global core.editor "nano --wait"
git config --global pull.rebase false

#####################################################################
####   Desktop Environment   ########################################
#####################################################################
personal=n
echo "Do you want to install the PIXEL desktop environment?"
while true; do
  read -p "Do you want to install the PIXEL desktop environment?" yn
  case $yn in
  [Yy]*)
    echo "Installing desktop packages"
    sudo apt install xserver-xorg -y
    sudo apt install raspberrypi-ui-mods -y
    sudo apt install synaptic -y
    sudo apt install chromium-browser -y
    break
    ;;
  [Nn]*) echo "Skipping desktop package installation..." ;;
  *) echo "Please answer yes or no." ;;
  esac
done
