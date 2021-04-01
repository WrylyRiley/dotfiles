#!/bin/zsh
#################################
# Path variables                #
#################################
export PATH=/Applications/Visual\ Studio\ Code.app/Contents/Re.s/app/bin:~/Library/Android/sdk/platform-tools:/usr/local/opt/tcl-tk/bin:~/.okta/bin:$PATH

#################################
# Required oh-my-zsh export     #
#################################
export ZSH=~/.oh-my-zsh

#################################
# Theming - Bullet train        #
#################################
ZSH_THEME="bullet-train"
# ZSH_THEME="robbyrussell"
export BULLETTRAIN_PROMPT_ORDER=(custom dir status git nvm aws time)

# Logic for random color selection
# color_key=(custom dir git nvm aws time font_color)
black="#000000" # font FG
white="#ffffff" # font FG
red="#ff0000"   # status BG
     void=("#180303" "#310904" "#4A0F04" "#621405" "#7B1A05" "#942006" $white)
     fire=("#6A040F" "#9D0208" "#D00000" "#DC2F02" "#E85D04" "#F48C06" $black)
    greys=("#808080" "#C0C0C0" "#E0E0E0" "#F0F0F0" "#F8F8F8" "#FFFFFF" $black)
   greens=("#34A0A4" "#52B69A" "#76C893" "#99D98C" "#B5E48C" "#D9ED92" $black)
  pastels=("#C09CFA" "#BFACFB" "#BEBCFC" "#BCCBFD" "#BBDBFE" "#BAEBFF" $black)
eggplants=("#4C2F34" "#59363C" "#653E45" "#72464E" "#72464E" "#8B555E" $white)

color_choice=void
# color_choice=$(python3 -c 'import random; print(random.choice(["fire","eggplants","greens","greys","pastels","void"]))')

export BULLETTRAIN_CUSTOM_FG=${${(P)color_choice}[7]}
export BULLETTRAIN_CUSTOM_BG=${${(P)color_choice}[1]}
export BULLETTRAIN_DIR_FG=${${(P)color_choice}[7]}
export BULLETTRAIN_DIR_BG=${${(P)color_choice}[2]}
export BULLETTRAIN_GIT_FG=${${(P)color_choice}[7]}
export BULLETTRAIN_GIT_BG=${${(P)color_choice}[3]}
export BULLETTRAIN_NVM_FG=${${(P)color_choice}[7]}
export BULLETTRAIN_NVM_BG=${${(P)color_choice}[4]}
export BULLETTRAIN_AWS_FG=${${(P)color_choice}[7]}
export BULLETTRAIN_AWS_BG=${${(P)color_choice}[5]}
export BULLETTRAIN_TIME_FG=${${(P)color_choice}[7]}
export BULLETTRAIN_TIME_BG=${${(P)color_choice}[6]}
export BULLETTRAIN_STATUS_ERROR_FG=$white
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
plugins=(git zsh-nvm colored-man-pages colored-man-pages yarn)
. $ZSH/oh-my-zsh.sh
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

#################################
# Yarn / NPM                    #
#################################
alias y="yarn | pino-pretty"
alias s="yarn start | pino-pretty"
alias d="yarn debug | pino-pretty"
alias t="yarn test | pino-pretty"

#################################
# Upside                        #
#################################
alias tfe="code $HOME/programming/upside/traveler-frontend"
alias hfe="code $HOME/programming/upside/horizon-frontend"
alias fro="code $HOME/programming/upside/frontdoor-ssr-service"
alias ees="code $HOME/programming/upside/email-experience-service"
alias tes="code $HOME/programming/upside/trips-experience-service"
ben() {
	open "https://upside.zoom.us/my/turboprop?pwd=VkFNRWUveGIzb08rekNPV3YvbENoZz09"
}
dockcore() {
	docker kill $(docker ps | grep "upsidetravel-docker.jfrog.io/core-db-schema:latest" | awk '{print $1}')
	docker images rm $(docker ps | grep "upsidetravel-docker.jfrog.io/core-db-schema:latest" | awk '{print $1}')
	docker pull upsidetravel-docker.jfrog.io/core-db-schema:latest
	docker run -d -p 3306:3306 --name coredb --rm upsidetravel-docker.jfrog.io/core-db-schema:latest
}
export AWS_PROFILE="upside-dev"
export TRAVELPORT_CREDS_P7142022="VW5pdmVyc2FsIEFQSS91QVBJNTM5MDU5ODI3NS00YWY2OTJkNDpXX2syOWRBJWp7"

#################################
# General development shortcuts #
#################################
alias prog="cd ~/programming"
alias zshrc="code ~/.zshrc"
alias ll="ls -lhaG"
alias c="clear"
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

# git
alias sgpm="gsta;gcm;gl;gstp"
pushit() { gcmsg "$1" && gp; }
pushall() {
	branch=$(git symbolic-ref --short HEAD)
	if [ $branch = master ]; then
		echo "You cannot commit to master"
	else
		# This is very Upside specific
		cut_branch=$([[ $branch = no* ]] && echo $branch | cut -c1-6 || echo $branch | cut -c1-9)
		gaa && gcmsg "[$cut_branch] $1" && gp
	fi
}
gcbp() { git checkout -B "$1" && git push --set-upstream origin "$1"; }
mmg() { branch=$(git symbolic-ref --short HEAD) && gcm && gl && gco $branch && git merge master; 
