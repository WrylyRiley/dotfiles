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
export BULLETTRAIN_PROMPT_ORDER=(custom dir status git nvm time)

# Logic for random color selection
# color_key=(custom dir git nvm aws time font_color)
black="#000000" # font FG
white="#ffffff" # font FG
red="#b00000"   # status BG
     void=("#310904" "#4A0F04" "#621405" "#7B1A05" "#942006" $white)
     fire=("#9D0208" "#D00000" "#DC2F02" "#E85D04" "#F48C06" $black)
    greys=("#C0C0C0" "#E0E0E0" "#F0F0F0" "#F8F8F8" "#FFFFFF" $black)
   greens=("#52B69A" "#76C893" "#99D98C" "#B5E48C" "#D9ED92" $black)
  pastels=("#BFACFB" "#BEBCFC" "#BCCBFD" "#BBDBFE" "#BAEBFF" $black)
eggplants=("#59363C" "#653E45" "#72464E" "#72464E" "#8B555E" $white)

# color_choice=void
color_choice=$(python3 -c 'import random; print(random.choice(["fire","eggplants","greens","greys","pastels","void"]))')

export BULLETTRAIN_CUSTOM_FG=${${(P)color_choice}[6]}
export BULLETTRAIN_CUSTOM_BG=${${(P)color_choice}[1]}
export BULLETTRAIN_DIR_FG=${${(P)color_choice}[6]}
export BULLETTRAIN_DIR_BG=${${(P)color_choice}[2]}
export BULLETTRAIN_GIT_FG=${${(P)color_choice}[6]}
export BULLETTRAIN_GIT_BG=${${(P)color_choice}[3]}
export BULLETTRAIN_NVM_FG=${${(P)color_choice}[6]}
export BULLETTRAIN_NVM_BG=${${(P)color_choice}[4]}
export BULLETTRAIN_TIME_FG=${${(P)color_choice}[6]}
export BULLETTRAIN_TIME_BG=${${(P)color_choice}[5]}
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

#################################
# General development shortcuts #
#################################
alias prog="cd ~/programming"
alias zshrc="code ~/.zshrc"
alias ll="ls -lhaG"
alias c="clear"
alias afk="pmset sleepnow"

# git
# overwriting zsh alias since we're using main instead of master
alias gcm="git checkout main"
alias sgpm="gsta;gcm;gl;gstp"
pushit() { gcmsg "$1" && gp; }
pushall() { gaa && gcmsg "$1" && gp }
gcbp() { git checkout -B "$1" && git push --set-upstream origin "$1"; }
mmg() { branch=$(git symbolic-ref --short HEAD) && gcm && gl && gco $branch && git merge main; }
 