. ./helpers.sh

{ [[ -d "$HOME/.oh-my-zsh" ]] && warn "oh-my-zsh already installed"; } || {
    inform "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

dir="$HOME/.oh-my-zsh/custom/plugins/autoupdate"
{ [[ -d $dir ]] && warn "autoupdate already installed"; } || {
    inform "Installing autoupdate"
    git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $dir
}

file="$HOME/.oh-my-zsh/themes/bullet-train.zsh-theme"
{ [[ -e $file ]] && warn "bullet-train already installed"; } || {
    inform "Installing bullet-train"
    curl -L -o $file http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
}

dir="$HOME/.oh-my-zsh/custom/plugins/zsh-nvm"
{ [[ -d $dir ]] && warn "zsh-nvm already installed"; } || {
    inform "Installing zsh-nvm"
    git clone https://github.com/lukechilds/zsh-nvm $dir
}

dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
{ [[ -d $dir ]] && warn "zsh-syntax-highlighting already installed"; } || {
    inform "Installing zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $dir
}

# zsh settings
inform "Backing up zshrc to $HOME/.zshrc.bak"
cp $HOME/.zshrc $HOME/.zshrc.bak
inform "Copying new config"
cp ./config/.zshrc $HOME/.zshrc
cp ./config/.aws_profile $HOME/.aws_profile
