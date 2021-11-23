#!/bin/bash

set -e

if [ ! -d /home/ys/code/ys/dotfiles ]; then
  echo "Cloning dotfiles"
  # the reason we dont't copy the files individually is, to easily push changes
  # if needed
  mkdir -p /home/ys/code/ys
  cd /home/ys/code/ys
  git clone --recursive https://github.com/ys/dotfiles.git
fi

cd /home/ys/code/ys/dotfiles
git remote set-url origin git@github.com:ys/dotfiles.git
chown -R ys:ys /home/ys/code
chown -R ys:ys /home/ys/secrets

sudo -i -u ys sh -c "cd /home/ys/code/ys/dotfiles && make sync"

/usr/sbin/sshd -D