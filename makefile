SHELL = /bin/bash
DOTFILES_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
PATH := $(DOTFILES_DIR)/bin:$(PATH)
OS := $(shell bin/is-supported bin/is-macos macos linux)
HOMEBREW_PREFIX := $(shell bin/is-supported bin/is-macos $(shell bin/is-supported bin/is-arm64 /opt/homebrew /usr/local) /home/linuxbrew/.linuxbrew)
SHELLS := /private/etc/shells
BASH_BIN := $(HOMEBREW_PREFIX)/bin/bash
BREW_BIN := $(HOMEBREW_PREFIX)/bin/brew
FNM_BIN := $(HOMEBREW_PREFIX)/bin/fnm
# export XDG_CONFIG_HOME = $(HOME)/.config
# export STOW_DIR = $(DOTFILES_DIR)
export ACCEPT_EULA=Y

$(info $$BASH_BIN is [${BASH_BIN}])

