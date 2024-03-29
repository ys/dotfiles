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
export PATH=/usr/local/opt/postgresql@15/bin:/opt/homebrew/bin:/usr/local/bin:$HOME/.cargo/bin:$HOME/src/heroku-shell/bin:$GOBIN:$HOME/bin:$GOPATH/bin:$PATH
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"

export LDFLAGS="-L/usr/local/opt/postgresql@15/lib"
export CPPFLAGS="-I/usr/local/opt/postgresql@15/include"

export PKG_CONFIG_PATH="/usr/local/opt/postgresql@15/lib/pkgconfig"


# Source all the .zsh files
for file in $HOME/.zsh/*; do source $file; done

[ -f /usr/local/opt/asdf/libexec/asdf.sh ] && . /usr/local/opt/asdf/libexec/asdf.sh
[ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ] && . /opt/homebrew/opt/asdf/libexec/asdf.sh


[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh
[ -f /usr/local/etc/profile.d/autojump.sh ] && . /usr/local/etc/profile.d/autojump.sh



test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export BUNDLER_EDITOR=vim
export EDITOR="nvim"
export HOMEBREW_INSTALL_BADGE=☕️

export DISABLE_SPRING=1


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Scaleway CLI autocomplete initialization.
eval "$(scw autocomplete script shell=zsh)"
