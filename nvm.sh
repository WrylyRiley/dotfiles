#!/usr/bin/env bash
. helpers.sh

######################################################################
# Global Node Modules
######################################################################
if which nvm >/dev/null; then
    warn "nvm already installed, skipping..."
else
    inform "Installing nvm and global node modules"
    wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
    nvm install --lts
    nvm use --lts
fi

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

if [[ $UPDATE == y ]]; then
    npm update -g @vue/cli @angular/cli create-react-app fkill nodemon typescript lerna expo-cli
    npm i -g npm
else
    npm i -g @vue/cli @angular/cli create-react-app fkill nodemon typescript lerna expo-cli
fi
