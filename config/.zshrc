######################################################################
# zsh setup
######################################################################
# path
export PATH=$HOME/Library/Android/sdk/platform-tools:/usr/local/opt/tcl-tk/bin:$HOME/.okta/bin:$HOME/bin:/usr/local/bin:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$HOME/Library/Python/3.7/bin:$PATH

# zsh
export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME="bullet-train"
export BULLETTRAIN_PROMPT_ORDER=(custom dir status git nvm virtualenv aws go rust elixir time)

# Logic for random color selection

COLOR_OPTION=$(python -S -c "import random; print random.randrange(0,4)")

export BULLETTRAIN_CUSTOM_FG="white"
export BULLETTRAIN_DIR_FG="white"
export BULLETTRAIN_GIT_FG="white"
export BULLETTRAIN_NVM_FG="white"
export BULLETTRAIN_TIME_FG="white"
export BULLETTRAIN_STATUS_ERROR_BG="#9D4EDD"

if (($COLOR_OPTION == 0)); then
	# Greens
	export BULLETTRAIN_CUSTOM_BG="#1B4332"
	export BULLETTRAIN_DIR_BG="#2D6A4F"
	export BULLETTRAIN_GIT_BG="#40916C"
	export BULLETTRAIN_NVM_BG="#52B788"
	export BULLETTRAIN_TIME_BG="#95D5B2"
	export BULLETTRAIN_TIME_FG="black"
elif (($COLOR_OPTION == 1)); then
	# Blues
	export BULLETTRAIN_CUSTOM_BG="#05131B"
	export BULLETTRAIN_DIR_BG="#113540"
	export BULLETTRAIN_GIT_BG="#1E5667"
	export BULLETTRAIN_NVM_BG="#2B768B"
	export BULLETTRAIN_TIME_BG="#3997B0"
elif (($COLOR_OPTION == 2)); then
	# Reds
	export BULLETTRAIN_CUSTOM_BG="#6A040F"
	export BULLETTRAIN_DIR_BG="#9D0208"
	export BULLETTRAIN_GIT_BG="#D00000"
	export BULLETTRAIN_NVM_BG="#DC2F02"
	export BULLETTRAIN_TIME_BG="#E85D04"
elif (($COLOR_OPTION == 3)); then
	# Gold
	export BULLETTRAIN_CUSTOM_BG="#805B10"
	export BULLETTRAIN_DIR_BG="#926C15"
	export BULLETTRAIN_GIT_BG="#A47E1B"
	export BULLETTRAIN_NVM_BG="#B69121"
	export BULLETTRAIN_TIME_BG="#C9A227"
else
	# Monochrome
	export BULLETTRAIN_CUSTOM_BG="#212529"
	export BULLETTRAIN_DIR_BG="#343A40"
	export BULLETTRAIN_GIT_BG="#495057"
	export BULLETTRAIN_NVM_BG="#6C757D"
	export BULLETTRAIN_TIME_BG="#ADB5BD"
	export BULLETTRAIN_TIME_FG="black"
fi

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
export BULLETTRAIN_PROMPT_CHAR="\\u21dd"
export BULLETTRAIN_STATUS_EXIT_SHOW=true

# Plugins
plugins=(git last-working-dir ng vscode zsh-nvm)
source $ZSH/oh-my-zsh.sh
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"                                       # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion

######################################################################
# Upside
######################################################################
alias y="yarn | pino-pretty"
alias s="yarn start | pino-pretty"
alias d="yarn debug | pino-pretty"

######################################################################
# General Development
######################################################################
alias please="sudo" # Wholesome
alias brewup="brew update; brew upgrade; brew prune; brew cleanup; brew doctor"
alias ns="npm start"
alias lockdock="defaults write com.apple.dock contents-immutable -bool true && killall Dock"
alias unlockdock="defaults write com.apple.dock contents-immutable -bool false && killall Dock"
alias prog="cd $HOME/programming"
alias zshrc="code $HOME/.zshrc"
alias ll="ls -lhaG"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias c="clear"

######################################################################
# git
######################################################################
alias gcl="git clone"
alias gl="git pull"
alias gp="git push"
alias gf="git fetch"
alias gs="git status"
alias gmm="git merge master"
alias gcmsg="git commit -m"
alias gaa="git add --all"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gcm="git checkout master"
alias gcd="git checkout development"
alias gb="git branch"
alias gbD="git branch -D"
pushit() {
	git commit -m "$1"
	git push
}
pushall() {
	git add --all
	git commit -m "$1"
	git push
}
gcbp() {
	git checkout -B "$1" && git push --set-upstream origin "$1"
}
mrb() {
	branch=$(git symbolic-ref --short HEAD)
	gcm; gl ; gco $branch; git rebase master 
}
alias con="git rebase --continue"
