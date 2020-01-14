######################################################################
# zsh setup
######################################################################
# path
export PATH=$HOME/bin:/usr/local/bin:/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin:$PATH

# zsh
export ZSH=$HOME/.oh-my-zsh

# default editor
export EDITOR=/usr/local/bin/micro

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
export BULLETTRAIN_PROMPT_CHAR="\\u21dd" # cool arrow
# export BULLETTRAIN_PROMPT_CHAR="\\u26a7" # trans symbol
# export BULLETTRAIN_PROMPT_CHAR="\\u2386" # APL enter symbol
export BULLETTRAIN_STATUS_EXIT_SHOW=true

# Plugins
plugins=(git last-working-dir ng vscode)
source $ZSH/oh-my-zsh.sh

######################################################################
# Deloitte - VectorXD
######################################################################
alias v="cd ~/programming/vector-xd"
alias wreck="npm run docker:down:destroy"
alias stor="npm run standup-dev"
alias testc="lerna run test --scope @vector/core --stream"
alias testa="lerna run test --scope @vector/api --stream"
alias testw="lerna run test --scope @vector/web-app --stream"
alias testv="lerna run test --stream"
alias testi="lerna run test:integration --stream"
alias jenk="ssh -L 8080:localhost:8080 vec-apps"
alias killskope="sudo launchctl unload /Library/LaunchDaemons/com.netskope.stagentsvc.plist"

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
alias gmm="git merge origin master"
alias gcmsg="git commit -m"
alias gaa="git add --all"
alias gco="git checkout"
alias gcb="git checkout -b"
alias gcm="git checkout master"
alias gcd="git checkout development"
alias gb="git branch"
alias gbD="git branch -D"
gcbp() {
	git checkout -B "$1" && git push --set-upstream origin "$1"
}
