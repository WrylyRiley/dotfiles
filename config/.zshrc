# path
export PATH=~/Library/Android/sdk/platform-tools:/usr/local/opt/tcl-tk/bin:~/.okta/bin:~/bin:/usr/local/bin:/Applications/Visual\ Studio\ Code.app/Contents/Re.s/app/bin:~/Library/Python/3.7/bin:$PATH

# zsh
export ZSH=~/.oh-my-zsh

# Theme
ZSH_THEME="bullet-train"
export BULLETTRAIN_PROMPT_ORDER=(custom dir status git nvm virtualenv aws go rust elixir time)

# Logic for random color selection
color_option=$(python -S -c "import random; print random.randint(0,5)")

export BULLETTRAIN_CUSTOM_FG="white"
export BULLETTRAIN_DIR_FG="white"
export BULLETTRAIN_GIT_FG="white"
export BULLETTRAIN_NVM_FG="white"
export BULLETTRAIN_TIME_FG="white"
export BULLETTRAIN_STATUS_ERROR_BG="#9D4EDD"

(($color_option == 0)) && {
	# Greens
	export BULLETTRAIN_CUSTOM_BG="#1B4332"
	export BULLETTRAIN_DIR_BG="#2D6A4F"
	export BULLETTRAIN_GIT_BG="#40916C"
	export BULLETTRAIN_NVM_BG="#52B788"
	export BULLETTRAIN_TIME_BG="#95D5B2"
	export BULLETTRAIN_TIME_FG="black"
}

(($color_option == 1)) && {
	# Blues
	export BULLETTRAIN_CUSTOM_BG="#05131B"
	export BULLETTRAIN_DIR_BG="#113540"
	export BULLETTRAIN_GIT_BG="#1E5667"
	export BULLETTRAIN_NVM_BG="#2B768B"
	export BULLETTRAIN_TIME_BG="#3997B0"
}

(($color_option == 2)) && {
	# Reds
	export BULLETTRAIN_CUSTOM_BG="#6A040F"
	export BULLETTRAIN_DIR_BG="#9D0208"
	export BULLETTRAIN_GIT_BG="#D00000"
	export BULLETTRAIN_NVM_BG="#DC2F02"
	export BULLETTRAIN_TIME_BG="#E85D04"
}

(($color_option == 3)) && {
	# Gold
	export BULLETTRAIN_CUSTOM_BG="#805B10"
	export BULLETTRAIN_DIR_BG="#926C15"
	export BULLETTRAIN_GIT_BG="#A47E1B"
	export BULLETTRAIN_NVM_BG="#B69121"
	export BULLETTRAIN_TIME_BG="#C9A227"
}

(($color_option == 4)) && {
	# Monochrome
	export BULLETTRAIN_CUSTOM_BG="#212529"
	export BULLETTRAIN_DIR_BG="#343A40"
	export BULLETTRAIN_GIT_BG="#495057"
	export BULLETTRAIN_NVM_BG="#6C757D"
	export BULLETTRAIN_TIME_BG="#ADB5BD"
	export BULLETTRAIN_TIME_FG="black"
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
alias gayagenda="npx github:mgwalker/raaainbow -m fullscreen"

# git
alias gmm="git merge master"
alias gcd="git checkout development"
alias con="git rebase --continue"
pushit() { gcmsg "$1" && gp; }
pushall() { gaa && gcmsg "$1" && gp; }
gcbp() { git checkout -B "$1" && git push --set-upstream origin "$1"; }
mrb() { branch=$(git symbolic-ref --short HEAD) && gcm && gl && gco $branch && git rebase master; }
