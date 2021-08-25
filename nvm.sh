. ./helpers.sh
# Global Node Modules
export NVM_DIR="$HOME/.nvm"
nvm="$NVM_DIR/nvm.sh"
nvmbash="$NVM_DIR/bash_completion"
modules="@vue/cli @angular/cli create-react-app yarn fkill nodemon lerna expo-cli pino-pretty"

{ [[ -s $nvm ]] && inform "NVM already installed..."; } || {
  inform "Installing NVM"
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
}
inform "loading NVM" && [[ -s $nvm ]] && . $nvm
inform "loading NVM bash completion" && [[ -s $nvmbash ]] && . $nvmbash
inform "loading node 14" && nvm install 14
inform "Installing global npm modules" && npm i -g $modules
