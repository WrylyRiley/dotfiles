#!/usr/bin/env bash
. helpers.sh

######################################################################
# oh-my-zsh
######################################################################
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    warn "oh-my-zsh already installed"
else
    inform "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

FILE=$HOME/.oh-my-zsh/themes/bullet-train.zsh-theme
[[ ! -f $FILE ]] && {
    inform "Installing bullet-train"
    curl -L -o $FILE http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
}

FILE=$HOME/.oh-my-zsh/custom/plugins/zsh-nvm
[[ ! -d $FILE ]] && {
    inform "Installing zsh-nvm"
    git clone https://github.com/lukechilds/zsh-nvm $FILE
}

FILE=$HOME/.oh-my-zsh/custom/plugins/autoupdate
[[ ! -d $FILE ]] && {
    inform "Installing autoupdate"
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $FILE
}

######################################################################
# zsh settings
######################################################################
inform "Backing up zshrc to ~/.zshrc.bak"
cp ~/.zshrc ~/.zshrc.bak
inform "Copying new config"
cp ./config/.zshrc ~/.zshrc
