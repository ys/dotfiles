all: sync install_vscode_packages

sync:
	echo $(PWD)
	[ -f ~/.ackrc ] || ln -s $(PWD)/ackrc ~/.ackrc
	[ -f ~/.agignore ] || ln -s $(PWD)/agignore ~/.agignore
	[ -f ~/.gemrc ] || ln -s $(PWD)/gemrc ~/.gemrc
	[ -f ~/.git_template ] || ln -s $(PWD)/git_template ~/.git_template
	[ -f ~/.gitconfig ] || ln -s $(PWD)/gitconfig ~/.gitconfig
	[ -f ~/.gitignore_global ] || ln -s $(PWD)/gitignore_global ~/.gitignore_global
	[ -f ~/.psqlrc ] || ln -s $(PWD)/psqlrc ~/.psqlrc
	[ -f ~/.tmux.conf ] || ln -s $(PWD)/tmux.conf ~/.tmux.conf
	[ -f ~/.vim ] || ln -s $(PWD)/vim ~/.vim
	[ -f ~/.vimrc ] || ln -s $(PWD)/vimrc ~/.vimrc
	[ -f ~/.zsh ] || ln -s $(PWD)/zsh ~/.zsh
	[ -f ~/.zshrc ] || ln -s $(PWD)/zshrc ~/.zshrc
	mkdir -p ~/.gnupg
	chmod 755 ~/.gnupg
	[ -f ~/.gnupg/gpg.conf ] || ln -s $(PWD)/gnupg/gpg.conf ~/.gnupg/gpg.conf
	[ -f ~/.gnupg/gpg-agent.conf ] || ln -s $(PWD)/gnupg/gpg-agent.conf ~/.gnupg/gpg-agent.conf
	@ln -s $(PWD)/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
	@ln -s $(PWD)/vscode/keybindings.json ~/Library/Application\ Support/Code/User/keybindings.json
	@ln -s $(PWD)/vscode/snippets ~/Library/Application\ Support/Code/User/snippets

install_vscode_packages:
	$(PWD)/vscode/install_vscode_packages

save_vscode_packages:
	code --list-extensions > $(PWD)/vscode/extensions.txt

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

.PHONY: all clean sync build run kill backup-bundle
