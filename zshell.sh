#!/usr/bin/env bash
. helpers.sh

######################################################################
# oh-my-zsh
######################################################################
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    warn "oh-my-zsh already installed"
else
    inform "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed '/\s*env\s\s*zsh\s*/d')"

fi
# Download and update these anyway
curl -L -o ~/.oh-my-zsh/themes/bullet-train.zsh-theme http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm

######################################################################
# zsh settings
######################################################################
inform "Backing up zshrc to ~/.zshrc.bak"
cp $HOME/.zshrc $HOME/.zshrc.bak
cp "./config/.zshrc" $HOME/.zshrc

######################################################################
# Change default shell to zsh
######################################################################
SH=$(echo $SHELL)
if [[ $SH == /bin/zsh ]]; then
    warn "zsh is already the default shell"
else
    inform "Changing default shell to zsh"
    chsh -s $(which zsh)
fi
source $HOME/.zshrc
