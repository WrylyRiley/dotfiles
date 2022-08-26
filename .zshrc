#!/bin/zsh 
#################################
# Path variables                #
#################################
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=/Applications/Visual\ Studio\ Code.app/Contents/Re.s/app/bin:/usr/local/opt/tcl-tk/bin:/opt/homebrew/bin:~/.jenv/bin:$PATH
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools
eval "$(jenv init -)"

#################################
# General exports               #
#################################
export ZSH=~/.oh-my-zsh
export LOCAL_IP=$(ifconfig -l | xargs -n1 ipconfig getifaddr)

#################################
# Theming - Bullet train        #
#################################
ZSH_THEME="bullet-train"
export BULLETTRAIN_PROMPT_ORDER=(custom dir status git nvm aws time)

# Logic for random color selection
# color_key=(custom dir git nvm aws time font_color)
black="#000000" # font FG
white="#ffffff" # font FG
red="#b00000"   # status BG
     void=("#180303" "#310904" "#4A0F04" "#621405" "#7B1A05" "#942006" $white)
     fire=("#6A040F" "#9D0208" "#D00000" "#DC2F02" "#E85D04" "#F48C06" $black)
    greys=("#808080" "#C0C0C0" "#E0E0E0" "#F0F0F0" "#F8F8F8" "#FFFFFF" $black)
   greens=("#34A0A4" "#52B69A" "#76C893" "#99D98C" "#B5E48C" "#D9ED92" $black)
  pastels=("#C09CFA" "#BFACFB" "#BEBCFC" "#BCCBFD" "#BBDBFE" "#BAEBFF" $black)
eggplants=("#4C2F34" "#59363C" "#653E45" "#72464E" "#72464E" "#8B555E" $white)

colors=(void fire greys greens pastels eggplants)
index=$(($RANDOM % ${#colors[@]} + 1))
color=${colors[$index]}

export BULLETTRAIN_CUSTOM_FG=${${(P)color}[7]}
export BULLETTRAIN_CUSTOM_BG=${${(P)color}[1]}
export BULLETTRAIN_DIR_FG=${${(P)color}[7]}
export BULLETTRAIN_DIR_BG=${${(P)color}[2]}
export BULLETTRAIN_GIT_FG=${${(P)color}[7]}
export BULLETTRAIN_GIT_BG=${${(P)color}[3]}
export BULLETTRAIN_NVM_FG=${${(P)color}[7]}
export BULLETTRAIN_NVM_BG=${${(P)color}[4]}
export BULLETTRAIN_AWS_FG=${${(P)color}[7]}
export BULLETTRAIN_AWS_BG=${${(P)color}[5]}
export BULLETTRAIN_TIME_FG=${${(P)color}[7]}
export BULLETTRAIN_TIME_BG=${${(P)color}[6]}
export BULLETTRAIN_STATUS_FG=$white
export BULLETTRAIN_STATUS_ERROR_BG=$red

export BULLETTRAIN_CUSTOM_MSG=𖤐
export BULLETTRAIN_TIME_12HR=true
export BULLETTRAIN_GIT_PROMPT_CMD="\$(custom_git_prompt)"
export BULLETTRAIN_PROMPT_CHAR="ᛒᚢᚾ"
export BULLETTRAIN_STATUS_EXIT_SHOW=true
custom_git_prompt() {
	prompt=$(git_prompt_info)
	prompt=${prompt//\//\ \ }
	prompt=${prompt//_/\ }
	echo ${prompt}
}

#################################
# oh-my-zsh plugins             #
#################################
plugins=(git zsh-nvm colored-man-pages yarn zsh-syntax-highlighting)
. $ZSH/oh-my-zsh.sh
export NVM_DIR="$HOME/.nvm"
nvm="$NVM_DIR/nvm.sh"
nvmbash="$NVM_DIR/bash_completion"
[[ -s $nvm ]] && . $nvm
[[ -s $nvmbash ]] && . $nvmbash

#################################
# Yarn / NPM                    #
#################################
alias y="yarn | pino-pretty"
alias s="yarn start | pino-pretty"
alias d="yarn debug | pino-pretty"
alias t="yarn test | pino-pretty"
alias b="yarn build | pino-pretty"
alias pi=".ios; pod install"
alias pim1=".ios; rm -rf Pods/; pod install"
alias pix64=".ios; rm -rf Pods/; arch -x86_64 pod install"


#################################
# General development shortcuts #
#################################
alias prog="cd ~/programming"
alias df="code ~/programming/dotfiles"
alias zshrc="code ~/.zshrc"
alias ll="ls -lhaG"
alias c="clear"
alias afk="pmset sleepnow"
export GPG_TTY=$(tty)

#################################
# Truebill                      #
#################################
# slack theme
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
export DATABASE_URL=postgres://truebill@localhost:25432/truebill_development
export TRANSACTIONS_DATABASE_URL=postgres://truebill@localhost:25432/truebill_transactions?sslmode=disable
alias sdm='yarn sequelize db:migrate'
alias tdm='yarn migrate:transactions up'
genmig() { .web && npx sequelize-cli migration:generate --name $1 }
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
# Rocket                        #
#################################
set_rocket_vpn_bash_variables() {
  echo "Currently connected to Rocket VPN!"
# update to the following (file path might be different for windows)
  if [[ ! -f /etc/ssl/certs/qlcerts.pem ]]; then
	  echo "Missing qlcerts.pem - downloading file"
    echo "Sudo is needed to DL the SSL certificate - please provide your password"
    sudo curl https://git.rockfin.com/raw/ansible-roles/qlcert/master/files/qlerts.pem -o /etc/ssl/certs/qlcerts.pem
  fi

  export AWS_CA_BUNDLE=/etc/ssl/certs/qlcerts.pem
  export NODE_EXTRA_CA_CERTS=/etc/ssl/certs/qlcerts.pem
  export QL_SELF_SIGNED_CAFILE=/etc/ssl/certs/qlcerts.pem
  export cafile=/etc/ssl/certs/qlcerts.pem
  export cacert=/etc/ssl/certs/qlcerts.pem   # for serverless
}

if [ -z "$(scutil --nwi | grep utun)" ]
then
    echo "Currently not connected to Rocket VPN"
else
    set_rocket_vpn_bash_variables
fi

alias vpnoff="open 'jamfselfservice://content?id=13546&action=execute&entity=policy'"
alias vpnon="open 'jamfselfservice://content?id=13548&action=execute&entity=policy'"
alias sudo="/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add && sudo "
alias brew="/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add && brew "

#################################
# Git                           #
#################################
alias sgpm="gsta;gcm;gl;gstp"
pushit() { git commit -S -m "$1" && gp; }
comit() { git commit -S -m "$1"; }
pushall() { gaa && git commit -S -m "$1" && gp }
comall() { gaa && git commit -S -m "$1" }
gcbp() { git checkout -B "$1" && git push --set-upstream origin "$1"; }
mmg() { branch=$(git symbolic-ref --short HEAD) && gcm && gl && gco $branch && git merge $(git_main_branch); }
 
#################################
# Tokens                        #
#################################
 
#################################
# Debug                         #
#################################
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}
