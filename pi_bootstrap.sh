# $1 = ip address of pi

cat ~/.ssh/id_ed25519.pub | ssh pi@$1 "mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys"
scp -r ./raspberry_pi pi@$1:/tmp
ssh pi@$1 'cd /tmp/raspberry_pi; chmod +x ./pi_headless.sh; . ./pi_headless.sh'
