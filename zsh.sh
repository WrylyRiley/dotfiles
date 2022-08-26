#####################################################################
####   NVM and global node modules @ node v14   #####################
#####################################################################
export NVM_DIR="$HOME/.nvm"
nvm="$NVM_DIR/nvm.sh"
nvmbash="$NVM_DIR/bash_completion"

{ [[ -s $nvm ]] && inform "NVM already installed..."; } || {
  inform "Installing NVM"
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
}
inform "loading NVM" && [[ -s $nvm ]] && . $nvm
inform "loading NVM bash completion" && [[ -s $nvmbash ]] && . $nvmbash
npm config delete prefix
inform "loading node 16" && nvm install 16
inform "Installing global npm modules" && npm i -g @vue/cli @angular/cli create-react-app yarn fkill nodemon lerna expo-cli pino-pretty

#####################################################################
####   python modules   #############################################
#####################################################################
# Needed to do physical device debuging with Flipper
inform "Installing IDB client for FLipper debugging"
pip3.6 install fb-idb

#####################################################################
####   oh-my-zsh, plugins, zsh settings   ###########################
#####################################################################
{ [[ -d "$HOME/.oh-my-zsh" ]] && warn "oh-my-zsh already installed"; } || {
  inform "Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

file="$HOME/.oh-my-zsh/themes/bullet-train.zsh-theme"
{ [[ -e $file ]] && warn "bullet-train already installed"; } || {
  inform "Installing bullet-train"
  curl -L -o $file http://raw.github.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
}

dir="$HOME/.oh-my-zsh/custom/plugins/autoupdate"
{ [[ -d $dir ]] && warn "autoupdate already installed"; } || {
  inform "Installing autoupdate"
  git clone -q https://github.com/TamCore/autoupdate-oh-my-zsh-plugins $dir
}

dir="$HOME/.oh-my-zsh/custom/plugins/zsh-nvm"
{ [[ -d $dir ]] && warn "zsh-nvm already installed"; } || {
  inform "Installing zsh-nvm"
  git clone -q https://github.com/lukechilds/zsh-nvm $dir
}

dir="$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
{ [[ -d $dir ]] && warn "zsh-syntax-highlighting already installed"; } || {
  inform "Installing zsh-syntax-highlighting"
  git clone -q https://github.com/zsh-users/zsh-syntax-highlighting.git $dir
}

inform "Backing up zshrc to ~/.zshrc.bak"
cp $HOME/.zshrc $HOME/.zshrc.bak
inform "Copying new config"
cp ./.zshrc $HOME/.zshrc
cp ./.aws_profile $HOME/.aws_profile
