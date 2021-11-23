backup-bundle:
	brew bundle dump --file $(PWD)/Brewfile.work -f

clean:
	rm -f ~/.ackrc
	rm -f ~/.agignore
	rm -f ~/.gemrc
	rm -rf ~/.git_template
	rm -f ~/.gitconfig
	rm -f ~/.gitignore_global
	rm -f ~/.psqlrc
	rm -f ~/.psqlrc
	rm -f ~/.tmux.conf
	rm -f ~/.vimrc
	rm -rf ~/.zsh
	rm -rf ~/.vim
	rm -f ~/.zshrc
	rm -rf ~/.gnupg

.PHONY: clean backup-bundle
