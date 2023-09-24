#!/bin/bash

##################################
# tooling                        #
##################################
. $BOOTSTRAP_UTILS
sudo apt update -y
sudo apt upgrade -y
sudo apt dist-upgrade -y

sudo apt install git -y
sudo apt install zsh -y
chsh -s /bin/zsh

##################################
# zsh setup                      #
##################################
succes "Installing zsh config"
zsh ../common/zsh/plugins_and_settings.zsh

cp ../common/zsh/.zshrc $HOME/.zshrc
success "Copied new .zshrc config"

##################################
# git preferences                #
##################################
success "Copying gitconfig to ~/.gitconfig"
cp ./.gitconfig ~/.gitconfig

##################################
# desktop environment            #
##################################
personal=n
inform "Do you want to install the PIXEL desktop environment?"
while true; do
  read -p "Do you want to install the PIXEL desktop environment?" yn
  case $yn in
  [Yy]*)
    success "Installing desktop packages"
    sudo apt install xserver-xorg -y
    sudo apt install raspberrypi-ui-mods -y
    sudo apt install synaptic -y
    sudo apt install chromium-browser -y
    break
    ;;
  [Nn]*) inform "Skipping desktop package installation..." ;;
  *) error "Please answer yes or no." ;;
  esac
done

zsh
