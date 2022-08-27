#!/bin/zsh
#################################
# Initialization and Prompt     #
#################################
autoload -U promptinit
eval "$(fnm env --use-on-cd)"
setopt prompt_subst MENU_COMPLETE no_list_ambiguous autocd

git_branch() {
  raw_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ ! $raw_branch == "" ]]; then echo '%F{100}<'$raw_branch'>%f'; fi
}
node_ver() { echo "%F{028}"$'\U2B21'"$(fnm current | sed 's/v//')%f"; }

PS1='%F{130}╭─%B%n%f%F{096}@%m%f%b %F{026}(%~)%f $(node_ver) $(git_branch) %f%(?..%F{196}[%?]%f)
%F{130}╰─'$'\U21A0''%f'

#################################
# Path variables                #
#################################
export ANDROID_HOME=$HOME/Library/Android/sdk
export ZSHCONFIG="$HOME/.config/zsh"
path+=("$ANDROID_HOME/emulator")
path+=("$ANDROID_HOME/tools")
path+=("$ANDROID_HOME/tools/bin")
path+=("$ANDROID_HOME/platform-tools")
path+=("/Applications/Visual\ Studio\ Code.app/Contents/Re.s/app/bin")
path+=("/usr/local/opt/tcl-tk/bin")
path+=("/opt/homebrew/bin")
path+=("$HOME/.jenv/bin")
export PATH
# Ensuring correct tty is used for gpg commit signing
export GPG_TTY=$(tty)

#################################
# Plugins                       #
#################################
autoload -Uz compinit && compinit
zstyle ':completion:*' menu yes select
source $ZSHCONFIG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSHCONFIG/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSHCONFIG/zsh-completions/zsh-completions.plugin.zsh
source $ZSHCONFIG/static_aliases.zsh
fpath=($ZSHCONFIG/fnm_completions $fpath)
fpath=($ZSHCONFIG/zsh-completions/src/_git $fpath)
fpath=($ZSHCONFIG/zsh-completions/src/_brew $fpath)
fpath=($ZSHCONFIG/zsh-completions/src/_brew_cask $fpath)
fpath=($ZSHCONFIG/zsh-completions/src/_man $fpath)
fpath=($ZSHCONFIG/zsh-completions/src/_pip $fpath)
fpath=($ZSHCONFIG/zsh-completions/src/_xcrun $fpath)
fpath=($ZSHCONFIG/zsh-completions/src/_yarn $fpath)

#################################
# Yarn / NPM                    #
#################################
alias y="yarn | pino-pretty"
alias s="yarn start | pino-pretty"
alias d="yarn debug | pino-pretty"
alias t="yarn test | pino-pretty"

#################################
# General development shortcuts #
#################################
alias prog="cd ~/programming"
alias zshrc="code ~/.zshrc"
alias ll="ls -lhaG"
alias c="clear"
alias afk="pmset sleepnow"
alias pihole="ssh pi@192.168.50.237"
alias pi4="ssh pi@rpi4.local"

# git
alias sgpm="gsta;gcm;gl;gstp"
pushit() { gcSm "$1" && gp; }
pushall() { gaa && gcSm "$1" && gp; }
gcbp() { gcb "$1" && gpsup "$1"; }
# backwards compatibility
mmg() { gmom; }

#################################
# Debug                         #
#################################
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

#################################
# Rocket General                #
#################################
# Truebill slack theme (RIP)
# #0059D2,#F0F0F0,#1C7AF9,#FFFFFF,#0C356C,#FAFAFA,#00B568,#FB5738,#0C356C,#FFFFFF

# Directories
alias .ios="cd ~/programming/truebill-native/ios"
alias .android="cd ~/programming/truebill-native/android"
alias .web="cd ~/programming/truebill/packages/web"
alias .legacyweb="cd ~/programming/truebill/packages/web-client"
alias .webclient="cd ~/programming/truebill/web-client"
alias .www="cd ~/programming/truebill/www"
alias .ops="cd ~/programming/truebill/scripts/ops"

# Database management
alias sdm='yarn sequelize db:migrate'
alias tdm='yarn migrate:transactions up'
genmig() { .web && npx sequelize-cli migration:generate --name $1; }
alias flushredis="docker exec -it truebill-web-redis redis-cli FLUSHALL"
alias monoreleases="convox releases -a truebill-2"

# VSCode shortcuts
alias tb=".code && code truebill"
alias tbn=".code && code truebill-native"

# Servers
# Dev app                                       : dockerstd, api|apidev, metro, build app in xcode
# Prod www (www.truebill.com)                   : dockerstd, api|apidev, wwwbuild, wwwserve
# Dev www (www.truebill.com)                    : dockerstd, api|apidev, wwwdev
# Dev legacy web-client (app.truebill.com)      : dockerstd, api|apidev, wwwdev, webapi, legacyweb
# Dev web-client (app.truebill.com)             : dockerstd, api|apidev, webclient
alias dockeres=".web && yarn run docker:es"
alias dockerstd=".web && yarn run docker"
alias indexes=".web && yarn run indexInstitutionsToElasticsearch"
alias api='.web && yarn dev'
alias metro=".ios && yarn start"
alias legacyweb=".legacyweb && yarn dev"
alias webclient=".webclient && yarn dev"
alias webapi=".web && yarn start:web"
alias wwwbuild=".www && yarn clean && yarn build"
alias wwwstart=".www && yarn serve"
alias wwwdev=".www && yarn start"
alias ip13pm=".ios; ..; arch -x86_64 npx react-native run-ios --simulator='iPhone 13 Pro Max'"
alias ip13pro=".ios; ..; arch -x86_64 npx react-native run-ios --simulator='iPhone 13 Pro'"
alias ip13mini=".ios; ..; arch -x86_64 npx react-native run-ios --simulator='iPhone 13 mini'"
alias andapp=".android && yarn android && adbr"
alias syncexp=".web && yarn syncCohortsAndExperiments ~/Downloads/experimentConfig.json"
alias clearxcode="rm -rf ~/Library/Developer/Xcode/DerivedData"
alias nukenative=".ios; rm -rf ../node_modules/; y; pix64;"
alias watchdel="watchman watch-del '/Users/RBauer1/programming/truebill-native' ; watchman watch-project '/Users/RBauer1/programming/truebill-native'"

# Android
alias adbr="adb reverse tcp:8081 tcp:8081"
alias adbrapi="adb reverse tcp:3000 tcp:3000"
alias shake="adb shell input keyevent 82"

#################################
# Rocket Environment            #
#################################
# Rocket Local DB URLs
export DATABASE_URL=postgres://truebill@localhost:25432/truebill_development
export TRANSACTIONS_DATABASE_URL=postgres://truebill@localhost:25432/truebill_transactions?sslmode=disable

# Rocket-specific certs
export AWS_CA_BUNDLE=/etc/ssl/certs/qlcerts.pem
export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/qlcerts.pem
export QL_SELF_SIGNED_CAFILE=/etc/ssl/certs/qlcerts.pem
export cafile=/etc/ssl/certs/qlcerts.pem
export cacert=/etc/ssl/certs/qlcerts.pem # for serverless

#################################
# Rocket Utils                  #
#################################
if [[ ! -z "$(scutil --nwi | grep utun)" ]]; then
  if [[ ! -f /etc/ssl/certs/qlcerts.pem ]]; then
    echo "Missing qlcerts.pem - downloading file"
    echo "Sudo is needed to DL the SSL certificate - please provide your password"
    sudo curl https://git.rockfin.com/raw/ansible-roles/qlcert/master/files/qlerts.pem -o /etc/ssl/certs/qlcerts.pem
  fi
fi

alias vpnoff="open 'jamfselfservice://content?id=13546&action=execute&entity=policy'"
alias vpnon="open 'jamfselfservice://content?id=13548&action=execute&entity=policy'"
alias sudo="/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add && sudo "
alias brew="/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add && brew "

#################################
# Rocket Tokens                 #
#################################
