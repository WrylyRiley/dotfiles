#################################
# Exports                       #
#################################
export ANDROID_HOME=$HOME/Library/Android/sdk
export ZSHCONFIG="$HOME/.config/zsh"
export EDITOR="code"
export HOMEBREW_NO_ENV_HINTS=true
export NO_HELPFUL_DIRENV_MESSAGES=true
export PATH="/Applications/Visual\ Studio\ Code.app/Contents/Re.s/app/bin:/opt/homebrew/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$HOME/.asdf/shims:$PATH"
# Ensuring correct tty is used for gpg commit signing
export GPG_TTY=$(tty)
export DIRENV_LOG_FORMAT=

#################################
# Initialization and Prompt     #
#################################
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000
setopt PROMPT_SUBST MENU_COMPLETE AUTOCD
setopt EXTENDED_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS INC_APPEND_HISTORY
unsetopt BEEP
unset zle_bracketed_paste
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' menu yes select

# Allows for using arrow keys to move through history that matches current input. e.g. `gco ^[[A` will match all git checkouts
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Themes
source $ZSHCONFIG/rileyb.zsh-theme
# source $ZSHCONFIG/agnoster.zsh-theme

#################################
# Plugins                       #
#################################
source $ZSHCONFIG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSHCONFIG/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSHCONFIG/zsh-completions/zsh-completions.plugin.zsh
source $ZSHCONFIG/static_aliases.zsh

# asdf
# source $HOME/.asdf/asdf.sh

# fzf
# [ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh

# direnv
eval "$(direnv hook zsh)"

# Completions
fpath=($ZSHCONFIG/zsh-completions/src $fpath)
fpath=(${ASDF_DIR}/completions $fpath)

autoload -Uz compinit && compinit -C
alias updatePlugins="cd $ZSHCONFIG && find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;"

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
alias dotf="code ~/programming/dotfiles"
alias zshrc="code ~/.zshrc"
alias ll="ls -lhaG"
alias c="clear"
alias afk="pmset sleepnow"
alias szsh="source ~/.zshrc"

# git
alias sgpm="gsta;gcm;gl;gstp"
pushit() { gcSm "$1" && gp; }
pushall() { gaa && gcSm "$1" && gp; }
gcbp() { gcb "$1" && gpsup; }
alias mmg="gmom" # backwards compatibility

#################################
# Debug                         #
#################################
# Enables zsh profiler that can give some insight into long running plugin loads
zmodload zsh/zprof

# runs 10 subshells and times them to interactivity
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

alias swatches='for x in 0 1 4 5 7 8; do for i in {30..37}; do for a in {40..47}; do echo -ne "\033[$x;$i;$a""m\\\033[$x;$i;$a""m\033[0;37;40m "; done; echo; done; done; echo "";'
alias reload='. ~/.zshrc'

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
alias andapp=".android && yarn android"
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

# We're on a Company laptop
if [[ -e /Applications/Privileges.app ]]; then
  alias vpnoff="open 'jamfselfservice://content?id=13546&action=execute&entity=policy'"
  alias vpnon="open 'jamfselfservice://content?id=13548&action=execute&entity=policy'"
  alias sudo="/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add && sudo"
  alias brew="/Applications/Privileges.app/Contents/Resources/PrivilegesCLI --add && brew"
fi

#################################
# Rocket Tokens                 #
#################################
