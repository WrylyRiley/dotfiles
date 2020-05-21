######################################################################
# zsh setup
######################################################################
# path
export PATH=$HOME/.okta/bin:$HOME/bin:/usr/local/bin:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$HOME/Library/Python/3.7/bin:$PATH

# zsh
export ZSH=$HOME/.oh-my-zsh

# default editor
# export EDITOR=/usr/local/bin/micro

# Theme
ZSH_THEME="bullet-train"
export BULLETTRAIN_PROMPT_ORDER=(
	custom
	dir
	status
	git
	nvm
	screen
	virtualenv
	aws
	go
	rust
	elixir
	context
	time
)
export BULLETTRAIN_CUSTOM_BG="cyan"
export BULLETTRAIN_CUSTOM_MSG=🐇
export BULLETTRAIN_CONTEXT_HOSTNAME="%m"
# export BULLETTRAIN_PROMPT_CHAR="\\u2021" # double-dagger
# export BULLETTRAIN_PROMPT_CHAR="\\u21dd" # cool arrow
# export BULLETTRAIN_PROMPT_CHAR="\\u26a7" # trans symbol
export BULLETTRAIN_PROMPT_CHAR="\\u2386" # APL enter symbol
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
alias reload="source $HOME/.zshrc"
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
alias gmm="git merge origin master"
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
alias heart="hh1 & hh2 & hh3 & hh5"
alias hc="cd $HOME/programming/heartbeat/heartbeat-card"
alias ha="cd $HOME/programming/heartbeat/heartbeat-app"
alias localenv="export LOCAL_TEST_MODE=true"

export BASH_SILENCE_DEPRECATION_WARNING=1

export JAVA_11_HOME=$(/usr/libexec/java_home -v11)
alias java11='export JAVA_HOME=$JAVA_11_HOME'

# default to Java 11
java11

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
