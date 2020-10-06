# path
export PATH=~/Library/Android/sdk/platform-tools:/usr/local/opt/tcl-tk/bin:~/.okta/bin:~/bin:/usr/local/bin:/Applications/Visual\ Studio\ Code.app/Contents/Re.s/app/bin:~/Library/Python/3.7/bin:$PATH

# zsh
export ZSH=~/.oh-my-zsh

# Theme
ZSH_THEME="bullet-train"
export BULLETTRAIN_PROMPT_ORDER=(custom dir status git nvm aws time)

# Logic for random color selection
color_option=$(python -S -c "import random; print random.randint(0,5)")

export BULLETTRAIN_CUSTOM_FG="white"
export BULLETTRAIN_DIR_FG="white"
export BULLETTRAIN_GIT_FG="white"
export BULLETTRAIN_NVM_FG="white"
export BULLETTRAIN_AWS_FG="white"
export BULLETTRAIN_TIME_FG="white"
export BULLETTRAIN_STATUS_ERROR_BG="#ff6f00"
export BULLETTRAIN_AWS_PREFIX="aws"

(($color_option == 0)) && {
	# Greens
	export BULLETTRAIN_CUSTOM_BG="#00695c"
	export BULLETTRAIN_DIR_BG="#008878"
	export BULLETTRAIN_GIT_BG="#00A591"
	export BULLETTRAIN_NVM_BG="#00C1AB"
	export BULLETTRAIN_AWS_BG="#00DEC4"
	export BULLETTRAIN_TIME_BG="#00FBDE"
}

(($color_option == 1)) && {
	# Ocean
	export BULLETTRAIN_CUSTOM_BG="#7400b8"
	export BULLETTRAIN_DIR_BG="#6930c3"
	export BULLETTRAIN_GIT_BG="#5e60ce"
	export BULLETTRAIN_NVM_BG="#5390d9"
	export BULLETTRAIN_AWS_BG="#4ea8de"
	export BULLETTRAIN_TIME_BG="#48bfe3"
}

(($color_option == 2)) && {
	# Fire
	export BULLETTRAIN_CUSTOM_BG="#9d0208"
	export BULLETTRAIN_DIR_BG="#d00000"
	export BULLETTRAIN_GIT_BG="#dc2f02"
	export BULLETTRAIN_NVM_BG="#e85d04"
	export BULLETTRAIN_AWS_BG="#f48c06"
	export BULLETTRAIN_TIME_BG="#faa307"
}

(($color_option == 3)) && {
	# Gold
	export BULLETTRAIN_CUSTOM_BG="#805B10"
	export BULLETTRAIN_DIR_BG="#966A13"
	export BULLETTRAIN_GIT_BG="#AE7B15"
	export BULLETTRAIN_NVM_BG="#C58C18"
	export BULLETTRAIN_AWS_BG="#DC9C1B"
	export BULLETTRAIN_TIME_BG="#E5A82D"
}

(($color_option == 4)) && {
	# mono
	export BULLETTRAIN_CUSTOM_BG="#212529"
	export BULLETTRAIN_DIR_BG="#343a40"
	export BULLETTRAIN_GIT_BG="#495057"
	export BULLETTRAIN_NVM_BG="#6c757d"
	export BULLETTRAIN_AWS_BG="#8e99a4"
	export BULLETTRAIN_TIME_BG="#a2adb9"
}

(($color_option == 5)) && {
	# Purple
	export BULLETTRAIN_CUSTOM_BG="#240046"
	export BULLETTRAIN_DIR_BG="#3c096c"
	export BULLETTRAIN_GIT_BG="#5a189a"
	export BULLETTRAIN_NVM_BG="#7b2cbf"
	export BULLETTRAIN_AWS_BG="#9d4edd"
	export BULLETTRAIN_TIME_BG="#c77dff"
}

# export BULLETTRAIN_CUSTOM_MSG=🐇
export BULLETTRAIN_CUSTOM_MSG=𖤐
export BULLETTRAIN_TIME_12HR=true
export BULLETTRAIN_GIT_PROMPT_CMD="\$(custom_git_prompt)"
custom_git_prompt() {
	prompt=$(git_prompt_info)
	prompt=${prompt//\//\ \ }
	prompt=${prompt//_/\ }
	echo ${prompt}
}
export BULLETTRAIN_GIT_MODIFIED=" %F{white}\\u002B%F{black}"
export BULLETTRAIN_GIT_ADDED=" %F{white}\\u229E%F{black}"
export BULLETTRAIN_GIT_UNTRACKED=" %F{white}\\u2A2E%F{black}"
export BULLETTRAIN_GIT_CLEAN=" %F{white}\\u2713%F{black}"
export BULLETTRAIN_GIT_DIRTY=" %F{white}\\u0078%F{black}"
export BULLETTRAIN_GIT_AHEAD=" %F{white}\\u21e7%F{black}"
export BULLETTRAIN_GIT_BEHIND=" %F{white}\\u21e9%F{black}"
export BULLETTRAIN_PROMPT_CHAR="\\u21dd"
export BULLETTRAIN_STATUS_EXIT_SHOW=true

# Shell Specific
export DISABLE_AUTO_TITLE="true"
precmd() {
	window_title="\033]0;${PWD##*/}\007"
	echo -ne "$window_title"
}

# Plugins
plugins=(git ng vscode zsh-nvm colored-man-pages yarn thefuck)
. $ZSH/oh-my-zsh.sh
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

# Yarn / NPM
alias y="yarn | pino-pretty"
alias s="yarn start | pino-pretty"
alias d="yarn debug | pino-pretty"
alias t="yarn test | pino-pretty"

# Upside
alias tfe="cd $HOME/programming/upside/traveler-frontend"
alias hfe="cd $HOME/programming/upside/horizon-frontend"
alias fro="cd $HOME/programming/upside/frontdoor-ssr-service"
v() {
	osascript &>/dev/null <<EOF
			tell application "Tunnelblick"
  			connect "upside"
			end tell
EOF
}
export AWS_PROFILE="upside-dev"

# General Development
alias please="sudo" # Wholesome
alias brewup="brew update; brew upgrade; brew prune; brew cleanup; brew doctor"
alias prog="cd ~/programming"
alias zshrc="code ~/.zshrc"
alias ll="ls -lhaG"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias c="clear"
alias afk='/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'

# git
alias gmm="git merge master"
alias gcd="git checkout development"
alias con="git rebase --continue"
pushit() { gcmsg "$1" && gp; }
pushall() { gaa && gcmsg "$1" && gp; }
com() { gaa && gcmsg "$1"; }
gcbp() { git checkout -B "$1" && git push --set-upstream origin "$1"; }
gbmm() { branch=$(git symbolic-ref --short HEAD) && gcm && gl && gco $branch && gmm; }
