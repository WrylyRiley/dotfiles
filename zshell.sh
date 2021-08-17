
. ./helpers.sh
# oh-my-zsh
if [[ -d "$HOME/.oh-my-zsh" ]]; then
    warn "oh-my-zsh already installed"
else 
    inform "Installing oh-my-zsh"; $ sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

file="$HOME/.oh-my-zsh/themes/bullet-train.zsh-theme"
if [[ -a $file ]]; then
    warn "bullet-train already installed"
else 
    inform "Installing bullet-train\n"; curl -L -o $file http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
fi

file="$HOME/.oh-my-zsh/custom/plugins/zsh-nvm"
if [[ -d $file ]]; then
    warn "zsh-nvm already installed"
else 
    inform "Installing zsh-nvm\n"; git clone https://github.com/lukechilds/zsh-nvm $file
fi

file="$HOME/.oh-my-zsh/custom/plugins/autoupdate"
if [[ -d $file ]]; then
    warn "autoupdate already installed"
else
    inform "Installing autoupdate\n"; git clone https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $file
fi

# zsh settings
inform "Backing up zshrc to ~/.zshrc.bak"
cp ~/.zshrc ~/.zshrc.bak
inform "Copying new config"
cp ./config/.zshrc ~/.zshrc
