#!/bin/bash

##################################
# tooling                        #
##################################
. $BOOTSTRAP_UTILS
# sudo apt update -y
# sudo apt install git -y
# sudo apt install zsh -y
# chsh -s /bin/zsh

##################################
# zsh setup                      #
##################################
inform "Installing zsh config"
zsh ./common/zsh/plugins_and_settings.zsh

cp ./common/zsh/.zshrc $HOME/.zshrc
success "Copied new .zshrc config"

# ##################################
# # git preferences                #
# ##################################
success "Copying gitconfig to ~/.gitconfig"
cp ./wsl/.gitconfig $HOME/.gitconfig

zsh
