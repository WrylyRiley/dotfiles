#!/usr/bin/env bash
. helpers.sh

######################################################################
# Global Node Modules
######################################################################
MODULES="@vue/cli @angular/cli create-react-app fkill nodemon typescript lerna expo-cli"

which nvm >/dev/null || wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

nvm install --lts
nvm use --lts

npm i -g $MODULES
