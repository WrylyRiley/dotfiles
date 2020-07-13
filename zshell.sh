#!/usr/bin/env bash
. helpers.sh
# oh-my-zsh
[[ -d "$HOME/.oh-my-zsh" ]] && warn "oh-my-zsh already installed" || { inform "Installing oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; }

file=$HOME/.oh-my-zsh/themes/bullet-train.zsh-theme
[[ ! -f $file ]] && { inform "Installing bullet-train" curl -L -o $file http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme; }

file=$HOME/.oh-my-zsh/custom/plugins/zsh-nvm
[[ ! -d $file ]] && { inform "Installing zsh-nvm" git clone https://github.com/lukechilds/zsh-nvm $file; }

file=$HOME/.oh-my-zsh/custom/plugins/autoupdate
[[ ! -d $file ]] && { inform "Installing autoupdate" git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $file; }
# zsh settings
inform "Backing up zshrc to ~/.zshrc.bak"
cp ~/.zshrc ~/.zshrc.bak
inform "Copying new config"
cp ./config/.zshrc ~/.zshrc
