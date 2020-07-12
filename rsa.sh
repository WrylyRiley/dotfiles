#!/usr/bin/env bash
. helpers.sh

######################################################################
# 1Password RSA
######################################################################
if [[ ! -d $HOME/.ssh ]]; then
	mkdir $HOME/.ssh
fi
inform "Please ensure your RSA keys are located in ~/.ssh before continung..."
read -n 1 -r -s CON
eval "$(ssh-agent -s)"
touch $HOME/.ssh/config
chmod 400 $HOME/.ssh/personal.pub $HOME/.ssh/personal
echo "Host *
    		AddKeysToAgent yes
    		UseKeychain yes
    		IdentityFile ~/.ssh/personal" >$HOME/.ssh/config
ssh-add -K $HOME/.ssh/personal
