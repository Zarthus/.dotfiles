.DEFAULT_GOAL := help

SYNC_DIRECTIVE := machine-server
INSTALL_TOOLS := no
OS := unknown

.check-dependency-ruby:
	@command -v ruby > /dev/null

.check-dependency-git:
	@command -v git > /dev/null

install:  ## Install everything (detects system)
ifeq ($(command -v apt),/usr/bin/apt)
	OS = ubuntu
else ifeq ($(command -v dnf),/usr/bin/dnf)
	OS = fedora
else ifeq ($OS,unknown)
	$(error "No valid OS found.")
endif
	$(call setup-home)
	$(call .install-os-generic)

.install-os-generic:
	# Install system software for ${OS} (with tooling: ${INSTALL_TOOLS})
	@make -f Makefile.${OS} install
ifneq ($INSTALL_TOOLS,no)
	@make -f Makefile.${OS} install-tools
endif

.change-shell-to-zsh:
ifneq ($SHELL,$(which zsh))
	chsh $(which zsh)
endif

configure-home: ## Set up the $HOME folder
	@mkdir ~/.config || true

install-oh-my-zsh: .check-dependency-git .change-shell-to-zsh  ## Install oh-my-zsh
	@export ZSH=~/.config/oh-my-zsh
	@sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

install-vundle-vim: .check-dependency-git  ## Install Vundle.vim in dotfiles/.vim/bundle
	@mkdir -p dotfiles/.vim/bundle
	@git clone https://github.com/VundleVim/Vundle.vim dotfiles/.vim/bundle/Vundle.vim

install-dotfiles: .check-dependency-ruby  ## Synchronize dotfiles with machine (default: machine-server, supply SYNC_DIRECTIVE env for other options)
	@cd tools
	@ruby sync.rb ${SYNC_DIRECTIVE}

help:  ## This very help command
	# Valid make targets:

	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | head -1
	@echo
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' | tail -n +2
	@echo

	# Note that as of right now this Makefile supports the following Operating Systems
	#  - Ubuntu 18.04
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
	#
	# To enable any option, run this Makefile like this:
	#  - `OPTION=value make target`
