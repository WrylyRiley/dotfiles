#!/bin/zsh 
#################################
# Path variables                #
#################################
export PATH=/Applications/Visual\ Studio\ Code.app/Contents/Re.s/app/bin:~/Library/Android/sdk/platform-tools:/usr/local/opt/tcl-tk/bin:$PATH

#################################
# Required oh-my-zsh export     #
#################################
export ZSH=~/.oh-my-zsh

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
alias pi="pod install"

#################################
# General development shortcuts #
#################################
alias .code="cd ~/code"
alias df="code ~/dotfiles"
alias zshrc="code ~/.zshrc"
alias ll="ls -lhaG"
alias c="clear"
alias afk="pmset sleepnow"

#################################
# Truebill                      #
#################################
# AWS Profile
. ~/.aws_profile
alias chawsprod='echo "export AWS_PROFILE=truebill-prod-eng-role" > ~/.aws_profile && zsh'
alias chawsstg='echo "export AWS_PROFILE=truebill-staging-eng-role" > ~/.aws_profile && zsh'
alias chawsdev='echo "export AWS_PROFILE=truebill-dev-eng-role" > ~/.aws_profile && zsh'

# Everything else 
export GITHUB_PACKAGE_TOKEN=""
alias sdm='DATABASE_URL="postgres://truebill@localhost:25432/truebill_development" yarn sequelize db:migrate'
alias tdm='TRANSACTIONS_DATABASE_URL="postgres://truebill@localhost:25432/truebill_transactions?sslmode=disable" yarn migrate:transactions up'
alias tbapi='DATABASE_URL="postgres://truebill@localhost:25432/truebill_development" yarn start'
genmig() {
  npx sequelize-cli migration:generate --name $1
}
alias .web="cd ~/code/truebill/packages/web"
alias .ios="cd ~/code/truebill-native/ios"
alias .tb="mrep && code truebill"
alias .tbn="mrep && code truebill-native"
alias dockeres=".web && yarn run docker:es"
alias indexes=".web && yarn run indexInstitutionsToElasticsearch"
alias mrep=".code && code ."

# git
# overwriting zsh alias since we're using main instead of master
alias gcm="git checkout master"
alias sgpm="gsta;gcm;gl;gstp"
pushit() { gcmsg "$1" && gp; }
pushall() { gaa && gcmsg "$1" && gp }
gcbp() { git checkout -B "$1" && git push --set-upstream origin "$1"; }
mmg() { branch=$(git symbolic-ref --short HEAD) && gcm && gl && gco $branch && git merge master; }
 