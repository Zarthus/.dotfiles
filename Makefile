.DEFAULT_GOAL := help
SHELL := /bin/bash

SYNC_DIRECTIVE ?= machine-server
INSTALL_TOOLS ?= no
OS ?= unknown
CHANGE_SHELL ?= yes

ifneq (${OS},unknown)
else ifeq ($(shell command -v apt),/usr/bin/apt)
OS := ubuntu
else ifeq ($(shell command -v dnf),/usr/bin/dnf)
OS := fedora
endif

.check-dependency-ruby:
	@command -v ruby > /dev/null

.check-dependency-git:
	@command -v git > /dev/null

.check-dependency-ohmyzsh:
	@test -d ${HOME}/.oh-my-zsh

.check-operating-system:
ifeq (${OS},unknown)
	$(error No valid OS found)
endif

install: .check-operating-system .install-os-generic install-oh-my-zsh install-vundle-vim install-dotfiles install-dotfiles-zsh-theme install-dotfiles-shell-aliases install-dotfiles-environment configure-git ## Install everything (detects system)
	# Installed for OS: ${OS}
	# All done. Consider the following actions:
	# - Generate GPG key (and use it with git)
	# - Install and configure tooling (bat, composer, exa, pygmentize)
	# - Set VM swappiness to 10 (or 1) on servers
	# - If on Debian, get debian-goodies
	# - Extend $$PATH
	# - Install .vim plugins (open vim, call :PluginInstall)

.install-os-generic: .check-operating-system configure-home
	# Install system software for ${OS} (with tooling: ${INSTALL_TOOLS})
	@make -f Makefile.${OS} install
ifneq (${INSTALL_TOOLS},no)
	@make -f Makefile.${OS} install-tools
endif

.change-shell-to-zsh:
ifneq (${CHANGE_SHELL},yes)
else ifneq (${SHELL},$(shell which zsh))
	# Changing your shell to zsh.
	chsh -s $(shell which zsh)
endif

clean:  ## Clean up the installation from your system (not implemented)
	@echo noop

configure-home:  ## Set up the $HOME folder
	@mkdir ~/.config || true
	@mkdir -p ~/.local/bin || true

configure-git:  ## Prompt the user for user.name, user.email if empty
ifeq ($(shell git config --global user.name),)
	@read -p "Please insert your git user.name: " name; \
		git config --global user.name "$$name"
	@read -p "Please insert your git user.email: " email; \
		git config --global user.email "$$email"
endif
	# Git user.name and user.email:
	@git config --global user.name || true
	@git config --global user.email || true

install-oh-my-zsh: .check-dependency-git .change-shell-to-zsh  ## Install oh-my-zsh
	@curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sed -E 's/\s+chsh/#chsh/' | sh

install-vundle-vim: .check-dependency-git  ## Install Vundle.vim in dotfiles/.vim/bundle
	@mkdir -p dotfiles/.vim/bundle
	@git clone https://github.com/VundleVim/Vundle.vim dotfiles/.vim/bundle/Vundle.vim || true

install-dotfiles: .check-dependency-ruby  ## Synchronize dotfiles with machine (default: machine-server, supply SYNC_DIRECTIVE env for other options)
	# Synchronize dotfiles (directive: ${SYNC_DIRECTIVE})
	@cd tools
	@ruby tools/sync.rb ${SYNC_DIRECTIVE}

install-dotfiles-zsh-theme: .check-dependency-ohmyzsh  ## Install the OhMyZsh custom Zarthus theme.
	@cp etc/zsh/themes/zarthus-two.zsh-theme ${HOME}/.oh-my-zsh/custom/themes/zarthus.zsh-theme
	@sed -i -E 's/ZSH_THEME=.*/ZSH_THEME="zarthus"/' ${HOME}/.zshrc

install-dotfiles-shell-aliases: .check-dependency-ohmyzsh  ## Source .config/shell_aliases.sh in .zshrc
	@[[ 0 -eq $(shell grep 'shell_aliases.sh' ${HOME}/.zshrc | wc -l) ]] && \
		echo -e "\nsource ${HOME}/.config/shell_aliases.sh\n" >> ${HOME}/.zshrc || true

install-dotfiles-environment: .check-dependency-ohmyzsh  ## Source .config/environment in .zshrc
	@[[ 0 -eq $(shell grep '.config/environment' ${HOME}/.zshrc | wc -l) ]] && \
		echo -e "source ${HOME}/.config/environment\n" >> ${HOME}/.zshrc || true

help:  ## This very help command
	# Valid make targets:

	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | head -1
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | tail -n +2
	@echo

	# Detected OS: ${OS}
	#
	# Note that as of right now this Makefile supports the following Operating Systems
	#  - Ubuntu 18.04 (and Debian 9)
	#  - Fedora 28 (untested)
	#
	# The "install" directive should be the only thing you need. Separate targets CAN
	# be ran but results may be unpredictable (especially if not ran on a new system).
	#
	# The following configuration variables are supported:
	#
	#  - INSTALL_TOOLS (valid values: no (default), anything else to install them)
	#     This will install extra system tools you might or might not need.
	#  - OS (valid values: fedora, ubuntu)
	#     The operating system being ran (automatically detected through `command -v packagemanager`)
	#  - SYNC_DIRECTIVE (valid values: machine, machine-server (default))
	#     The option passed to tools/sync.rb
	#  - CHANGE_SHELL (valid values: yes (default), no)
	#
	# To enable any option, run this Makefile like this:
	#  - `OPTION=value make target`
