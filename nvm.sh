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
[[ -s $nvm ]] && . $nvm
[[ -s $nvmbash ]] && . $nvmbash
nvm install 14
npm i -g $modules
