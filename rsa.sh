. ./helpers.sh
# RSA
mkdir -p $HOME/.ssh
warn "Please ensure your RSA keys are located in $HOME/.ssh before continuing..."
read -n 1 -r -s CON
inform "Adding keys to ssh-agent"
eval "$(ssh-agent -s)"
touch $HOME/.ssh/config
chmod 400 $HOME/.ssh/personal.pub $HOME/.ssh/personal
echo "Host *
    	AddKeysToAgent yes
    	UseKeychain yes
    	IdentityFile $HOME/.ssh/personal" >$HOME/.ssh/config
ssh-add -K $HOME/.ssh/personal
