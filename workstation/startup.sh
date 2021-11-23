#!/bin/bash

set -eu

echo "Authenticating with 1Password"
export OP_SESSION_my=$(op signin https://my.1password.com yannick.schutz@gmail.com --output=raw)

echo "Pulling secrets"
# private keys
op get document "kr.me" > ~/secrets/krme
op get document "ngrokyml" > ~/secrets/ngrokyml
op get document "zsh_history" > ~/secrets/zsh_history

rm -f ~/.kr/me
rm -f ~/.zsh_history
rm -f ~/.ngrok2/ngrok.yml
mkdir -p ~/.kr
mkdir -p ~/.ngrok2
ln -s ~/secrets/krme ~/.kr/me
ln -s ~/secrets/zsh_history ~/.zsh_history
ln -s ~/secrets/ngrokyml ~/.ngrok2/ngrok.yml

echo "Done!"


PASSWORD="$(op get item code-server.vps | jq .details.password -r)"
/usr/local/bin/code-server -p 8443 -d /home/ys -P ${PASSWORD} &> /tmp/coder.log &