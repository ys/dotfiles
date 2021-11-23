# Disable flow control commands (keeps C-s from freezing everything)
stty start undef
stty stop undef

setopt prompt_subst
setopt NO_BEEP
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export GOPATH=~/go
export GOBIN=~/go/bin
export PATH=/opt/homebrew/bin:/usr/local/bin:$HOME/src/heroku-shell/bin:$GOBIN:$HOME/bin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"


# Source all the .zsh files
for file in $HOME/.zsh/*; do source $file; done

eval "$(jump shell)"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export BUNDLER_EDITOR=vim
export EDITOR=vim
export HOMEBREW_INSTALL_BADGE=☕️

export DISABLE_SPRING=1


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
