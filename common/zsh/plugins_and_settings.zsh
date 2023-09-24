. $BOOTSTRAP_UTILS
export ZSHCONFIG=$HOME/.config/zsh
mkdir -p $ZSHCONFIG
dir=$ZSHCONFIG/zsh-syntax-highlighting
if [[ ! -d $dir ]]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $dir
  success "Installed zsh syntax highlighting"
else
  inform "zsh syntax highlighting already installed. Run updatePlugins to pull changes"
fi

dir=$ZSHCONFIG/zsh-autosuggestions
if [[ ! -d $dir ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions.git $dir
  success "Installed zsh autosuggestions"
else
  inform "zsh autosuggestions already installed. Run updatePlugins to pull changes"
fi

dir=$ZSHCONFIG/zsh-completions
if [[ ! -d $dir ]]; then
  git clone https://github.com/zsh-users/zsh-completions.git $dir
  success "Installed zsh completions"
else
  inform "zsh completions already installed. Run updatePlugins to pull changes"
fi

dir=$ZSHCONFIG/zsh-history-substring-search
if [[ ! -d $dir ]]; then
  git clone https://github.com/zsh-users/zsh-history-substring-search.git $dir
  success "Installed zsh history substring search"
else
  inform "zsh history string subsearch already installed. Run updatePlugins to pull changes"
fi

if [[ ! -e $ZSHCONFIG/static_aliases.zsh ]]; then
  cp ./common/zsh/static_aliases.zsh $ZSHCONFIG
  success "Copied static aliases"
else
  inform "Static aliases already installed."
fi

if [[ ! -e $ZSHCONFIG/rileyb.zsh-theme ]]; then
  cp ./common/zsh/rileyb.zsh-theme $ZSHCONFIG
  success "installed rileyb theme"
fi

if [[ ! -e $ZSHCONFIG/agnoster.zsh-theme ]]; then
  cp ./common/zsh/agnoster.zsh-theme $ZSHCONFIG
  success "installed agnoster theme"
fi

cp $HOME/.zshrc "$ZSHCONFIG/.zshrc_$(date "+ %a_%b_%Y_%e_%H:%M:%S")"
success "Backed up ~/.zshrc to ~/.config/.zsh/.zshrc[DATE]"
