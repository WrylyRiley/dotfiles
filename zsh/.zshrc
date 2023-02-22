#################################
# Debug                         #
#################################
# Enables zsh profiler that can give some insight into long running plugin loads
# zmodload zsh/zprof

# runs 10 subshells and times them to interactivity
timezsh() {
  shell=${1-$SHELL}
  for i in $(seq 1 10); do /usr/bin/time $shell -i -c exit; done
}

alias swatches='for x in 0 1 4 5 7 8; do for i in {30..37}; do for a in {40..47}; do echo -ne "\033[$x;$i;$a""m\\\033[$x;$i;$a""m\033[0;37;40m "; done; echo; done; done; echo "";'
alias reload='. ~/.zshrc'

#################################
# Exports                       #
#################################
export ANDROID_HOME=$HOME/Library/Android/sdk
export ZSHCONFIG="$HOME/.config/zsh"
export EDITOR="code"
export HOMEBREW_NO_ENV_HINTS=true
export NO_HELPFUL_DIRENV_MESSAGES=true
export PATH="usr/local/bin:/Applications/Visual\ Studio\ Code.app/Contents/Re.s/app/bin:/opt/homebrew/bin:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools:$HOME/.asdf/shims:/opt/homebrew/opt/ccache/libexec:$PATH"
# Ensuring correct tty is used for gpg commit signing
export GPG_TTY=$(tty)
export DIRENV_LOG_FORMAT=

#################################
# Initialization and Prompt     #
#################################
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt PROMPT_SUBST MENU_COMPLETE AUTOCD
setopt EXTENDED_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS INC_APPEND_HISTORY
unsetopt BEEP
unset zle_bracketed_paste
_comp_options+=(globdots)
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' menu yes select

# Themes
source $ZSHCONFIG/rileyb.zsh-theme
# source $ZSHCONFIG/agnoster.zsh-theme

#################################
# Plugins                       #
#################################
source /Users/RBauer1/.config/op/plugins.sh
source $ZSHCONFIG/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZSHCONFIG/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZSHCONFIG/zsh-completions/zsh-completions.plugin.zsh
source $ZSHCONFIG/zsh-history-substring-search/zsh-history-substring-search.zsh
source $ZSHCONFIG/static_aliases.zsh

# Bind up and down to zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
# only match beginning of command instead of anywhere in the string
HISTORY_SUBSTRING_SEARCH_PREFIXED=1
# Ensure no duplicates
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=1
# Remove coloring for matches
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=

# direnv
eval "$(direnv hook zsh)"

# asdf java (much more performant than jenv)
. ~/.asdf/plugins/java/set-java-home.zsh

# Completions
fpath=($ZSHCONFIG/zsh-completions/src $fpath)
fpath=(${ASDF_DIR}/completions $fpath)

autoload -Uz compinit && compinit -C
alias updatePlugins="cd $ZSHCONFIG && find . -type d -depth 1 -exec git --git-dir={}/.git --work-tree=$PWD/{} pull origin master \;"

#################################
# Yarn / NPM                    #
#################################
alias y="yarn"
alias s="yarn start"
alias d="yarn debug"
alias t="yarn test"
alias b="yarn build"

#################################
# General development shortcuts #
#################################
alias prog="cd ~/programming"
alias dotf="code ~/programming/dotfiles"
alias zshrc="code ~/.zshrc"
alias ll="ls -lhaG"
alias c="clear"
alias afk="pmset sleepnow"

# git
alias sgpm="gsta;gcm;gl;gstp"
pushit() { gcSm "$1" && gp; }
pushall() { gaa && gcSm "$1" && gp; }
gcbp() { gcb "$1" && gpsup; }
comall() { gaa && gcSm "$1"; }
