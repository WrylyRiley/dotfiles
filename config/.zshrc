######################################################################
# zsh setup
######################################################################
# path
export PATH=$HOME/.okta/bin:$HOME/bin:/usr/local/bin:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$HOME/Library/Python/3.7/bin:$PATH

# zsh
export ZSH=$HOME/.oh-my-zsh

# Theme
ZSH_THEME="bullet-train"
export BULLETTRAIN_PROMPT_ORDER=(custom dir status git nvm virtualenv aws go rust elixir time)

# Logic for random color selection
COLOR_OPTION=$(awk 'BEGIN{srand(); print int(4+rand()*4)}')

export BULLETTRAIN_CUSTOM_FG="white"
export BULLETTRAIN_DIR_FG="white"
export BULLETTRAIN_GIT_FG="white"
export BULLETTRAIN_NVM_FG="white"
export BULLETTRAIN_TIME_FG="white"
export BULLETTRAIN_STATUS_ERROR_BG="#9D4EDD"

if [[ $COLOR_OPTION < 2 ]]; then
	# Greens
	export BULLETTRAIN_CUSTOM_BG="#1B4332"
	export BULLETTRAIN_DIR_BG="#2D6A4F"
	export BULLETTRAIN_GIT_BG="#40916C"
	export BULLETTRAIN_NVM_BG="#52B788"
	export BULLETTRAIN_TIME_BG="#95D5B2"
	export BULLETTRAIN_TIME_FG="black"
elif [[ $COLOR_OPTION < 4 ]]; then
	# Blues
	export BULLETTRAIN_CUSTOM_BG="#05131B"
	export BULLETTRAIN_DIR_BG="#113540"
	export BULLETTRAIN_GIT_BG="#1E5667"
	export BULLETTRAIN_NVM_BG="#2B768B"
	export BULLETTRAIN_TIME_BG="#3997B0"
elif [[ $COLOR_OPTION < 6 ]]; then
	# Reds
	export BULLETTRAIN_CUSTOM_BG="#6A040F"
	export BULLETTRAIN_DIR_BG="#9D0208"
	export BULLETTRAIN_GIT_BG="#D00000"
	export BULLETTRAIN_NVM_BG="#DC2F02"
	export BULLETTRAIN_TIME_BG="#E85D04"
elif [[ $COLOR_OPTION < 8 ]]; then
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

# export BULLETTRAIN_PROMPT_CHAR="\\u2021"    # double-dagger
export BULLETTRAIN_PROMPT_CHAR="\\u21dd" # cool arrow
# export BULLETTRAIN_PROMPT_CHAR="\\u26a7"    # trans symbol
# export BULLETTRAIN_PROMPT_CHAR="\\u2386"    # APL enter symbol

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
	git add --all
	git commit -m "$1"
	git push
}
gcbp() {
	git checkout -B "$1" && git push --set-upstream origin "$1"
}
alias mrebase="git rebase origin/master"
alias con="git rebase --continue"

######################################################################
# Heartbeat Health
######################################################################
alias hc="cd $HOME/programming/heartbeat/heartbeat-card"
alias ha="cd $HOME/programming/heartbeat/heartbeat-app"
alias localenv="export LOCAL_TEST_MODE=true"

export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
export JAVA_HOME=$JAVA_11_HOME
export LIQUIBASE_HOME=/usr/local/opt/liquibase/libexec

jdk() {
	version=$1
	export JAVA_HOME=$(/usr/libexec/java_home -v"$version")
	java -version
}

source ~/.okta/bash_functions

hbhdev() {
	#OktaAWSCLI sign-in
	if [[ -f "$HOME/.okta/bash_functions" ]]; then
		. "$HOME/.okta/bash_functions"
	fi

	if [[ -d "$HOME/.okta/bin" && ":$PATH:" != *":$HOME/.okta/bin:"* ]]; then
		PATH="$HOME/.okta/bin:$PATH"
	fi

	okta-aws hbh-iam-manager sts get-caller-identity
	eval $(assume-role hbh-dev)
}
