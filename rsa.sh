
. ./helpers.sh
# RSA
[[ ! -d ~/.ssh ]] && mkdir ~/.ssh
inform "Please ensure your RSA keys are located in ~/.ssh before continung..."
read -n 1 -r -s CON
eval "$(ssh-agent -s)"
touch ~/.ssh/config
chmod 400 ~/.ssh/personal.pub ~/.ssh/personal
echo "Host *
    	AddKeysToAgent yes
    	UseKeychain yes
    	IdentityFile ~/.ssh/personal" >~/.ssh/config
ssh-add -K ~/.ssh/personal
