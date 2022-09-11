autoload -Uz promptinit
HEXAGON=$'\u2b21'
ARROW=$'\u21a0'

NAME="%F{130}╭─%B%n%f%b"
HOSTNAME="%B%F{096}@%m%f%b"
CURRENT_TIME="%F{026}%*%f"
CURRENT_PATH="%F{026}(%~)%f"
ERR_STATE="%f%(?..%F{196}[%?]%f)"
PROMPT_BOTTOM="%F{130}╰─$ARROW%f"

node_ver() {
  raw_node_ver=$(asdf current nodejs | grep -Eo '[0-9]+.[0-9]+.[0-9]+')
  if [[ ! $raw_node_ver == "" ]]; then echo "%F{028}${HEXAGON}${raw_node_ver}%f"; fi
}

git_branch() {
  raw_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
  if [[ ! $raw_branch == "" ]]; then echo '%F{100}<'$raw_branch'>%f'; fi
}

PS1='${NAME}${HOSTNAME} $CURRENT_TIME $CURRENT_PATH $(node_ver) $(git_branch) $ERR_STATE
$PROMPT_BOTTOM'
