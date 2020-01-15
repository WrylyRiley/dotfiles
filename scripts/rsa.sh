######################################################################
# LastPass RSA download
######################################################################

# Add folders and files
mkdir $HOME/.ssh
touch $HOME/.ssh/personal.pub
touch $HOME/.ssh/personal
# Start ssh agent
eval "$(ssh-agent -s)"
# Get keys
lpass login --trust zbauer91@gmail.com # Sign in to LastPass CLI
inform "Retrieving public key"
lpass show -c --field="Public Key" personal_rsa_key
pbpaste >$HOME/.ssh/personal.pub
inform "Retrieving private key"
lpass show -c --field="Private Key" personal_rsa_key
pbpaste >$HOME/.ssh/personal
# Set permissions
chmod 400 $HOME/.ssh/personal.pub $HOME/.ssh/personal
# Set config for Sierra+
echo "Host *
    AddKeysToAgent yes
    UseKeychain yes
    IdentityFile ~/.ssh/personal" >$HOME/.ssh/config
# Add new key to ssh agent
