
export BOOTSTRAP_UTILS=$BOOTSTRAP_ROOT/common/utils.sh

error() {
  if [ -n "$ZSH_VERSION" ]; then
    printf "\x1b[1;31m❌ $1\x1b[0m\n"
  else
    echo "\e[31m❌ $1\e[0m"
  fi
}
inform() {
  if [ -n "$ZSH_VERSION" ]; then
    printf "\x1b[1;34m💡 $1\x1b[0m\n"
  else
    echo "\e[34m💡 $1\e[0m"
  fi
}
success() {
  if [ -n "$ZSH_VERSION" ]; then
    printf "\x1b[1;32m✅ $1\x1b[0m\n"
  else
    echo "\e[32m✅ $1\e[0m"
  fi
}
