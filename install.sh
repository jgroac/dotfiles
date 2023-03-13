#!/bin/bash

source utils/logger.sh
source utils/helpers.sh
source macos/defaults.sh


to_bold "${tan}┌──────────────────────────────────────────────────────────────┐
|  Welcome!!                                                   |
|                                                              |
| This will overwrite your system configuration.               |
| Do you want to proceed (y/N)?                                |
└──────────────────────────────────────────────────────────────┘"

if prompt_confirm; then
  to_error "Aborting..."
  exit 1;
fi

###############################################################################
# Git config                                                                  #
###############################################################################

to_header "Git config"

ask "${blue} Do you want to config git (y/n):"
set_git_config="$(prompt_confirm)"

cp .gitignore ~/.gitignore_global  ## Adding .gitignore global
git config --global core.excludesfile "${HOME}/.gitignore_global"

if [[ set_git_config -eq 1 ]]; then

  ask "${blue} Git email:"
  read -r userEmail
  if is_empty $userEmail; then
    git config --global user.email "$userEmail"
    to_success "Email is set"
  else
    to_warning "Not set"
  fi

  ask "${blue} Git username:"
  read -r userName
  if is_empty $userName; then
    git config --global user.name "$userName"
    to_success "Username is set"
  else
    to_warning "Not set"
  fi
else
  to_warning "Skipping git setup..."
fi


###############################################################################
# Homebrew                                                                    #
###############################################################################

if test ! $(which brew); then
  to_header "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  to_warning "Homebrew is already installed. Skipping..."
fi

###############################################################################
# System                                                                      #
###############################################################################

if test ! $(which dockutil); then
  to_header "Installing dockutil..."
  brew install dockutil
else
  to_warning "dockutil is already installed. Skipping..."
fi

if test ! $(which coreutils); then
  to_header "Installing coreutils..."
  brew install coreutils
else
  to_warning "coreutils is already installed. Skipping..."
fi


###############################################################################
# Terminal                                                                    #
###############################################################################

if ! is_installed 'iTerm' &>/dev/null;
then
  to_header "Installing iTerm..."
  brew install --cask iterm2
fi

if ! is_installed 'Alacritty' &>/dev/null;
then
  to_header "Installing Alacritty...."
  brew install --cask alacritty
fi

###############################################################################
# Ohmyzsh                                                                     #
###############################################################################
ZSH=~/.oh-my-zsh

if [ -d "$ZSH" ]; then
  to_warning "ZSH is already installed. Skipping..."
else
  to_header "Installing ZSH..."
  curl -L http://install.ohmyz.sh | sh

  ## To install ZSH themes & aliases
  to_header "Copying ZSH themes & aliases..."
  to_note "Check .aliases file for more details."
  cp terminal/aliases ~/.aliases
  cp terminal/zshrc ~/.zshrc
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k ## zsh theme
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ## Copy syntax higlighting pluging
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ## Copy autosuggestions pluging

  # Install powerline fonts
  to_header "Install powerline fonts..."
  git clone https://github.com/powerline/fonts.git --depth=1
  cd fonts
  bash ./install.sh
  cd ..
  rm -rf fonts
fi

###############################################################################
# Languages                                                                   #
###############################################################################

## Install fnm Nodejs version manager
if ! type fnm > /dev/null
then
  to_header "Installing Nodejs version manager..."
  curl -fsSL https://fnm.vercel.app/install | bash
fi

## Print installed node, npm version
echo "node --version: $(node --version)"
echo "npm --version: $(npm --version)"

## Yarn install
if ! type yarn > /dev/null
then
  to_header "Install yarn..."
  npm install --global yarn
fi

## Go lang
if ! type go > /dev/null
then
  to_header "Installing go..."
  brew install go
fi

###############################################################################
# Commandline Tools                                                           #
###############################################################################

## Install ctop
if ! type fnm > /dev/null
then
  to_header "Installing ctop..."
  brew install ctop
fi

## thefuck
if ! type fuck > /dev/null
then
  to_header "Installing thefuck..."
  brew install thefuck
fi

## Bat
if ! type bat > /dev/null
then
  to_header "Installing bat..."
  brew install bat

  to_header "Installing bat themes.."
  mkdir -p "$(bat --config-dir)/themes"
  cd "$(bat --config-dir)/themes"

  # Download a theme in '.tmTheme' format, for example:
  git clone https://github.com/batpigandme/night-owlish

  # Update the binary cache
  bat cache --build
fi

## Ripgrep
if ! type rg > /dev/null
then
  to_header "Installing ripgrep..."
  brew install ripgrep
fi

## Commandline fuzzy finder
if ! type fzf > /dev/null
then
  to_header "Installing fzf..."
  brew install fzf
fi

## Json jq
if ! type jq > /dev/null
then
  to_header "Installing jq..."
  brew install jq
fi

## Github CLI
if ! type jq > /dev/null
then
  to_header "Installing Github CLI..."
  brew install gh
fi

## Croc to send file securely
if ! type croc > /dev/null
then
  to_header "Installing croc..."
  brew install croc
fi

## User-friendly cURL
if ! type httpie > /dev/null
then
  to_header "Installing httpie..."
  brew install httpie
fi

## Better cd
if ! type httpie > /dev/null
then
  to_header "Installing z..."
  brew install zoxide
fi

## Tree
if ! type tree > /dev/null
then
  to_header "Installing tree..."
  brew install tree
fi

## git-delta
if ! type delta > /dev/null
then
  to_header "Installing git-delta..."
  # brew install git-delta
  git config --global core.pager "delta --plus-color=\"#012800\" --minus-color=\"#340001\" --theme=\"night-owlish\""
  git config --global interactive.diffFilter "delta --color-only"
fi


## Tree
if ! type tree > /dev/null
then
  to_header "Installing tree..."
  brew install tree
fi

###############################################################################
# Apps                                                                        #
###############################################################################

## Vscode
if ! is_installed 'Visual Studio Code' &>/dev/null;
then
  to_header "Installing Visual Studio Code..."
  brew cask install visual-studio-code
fi


## Sublime
if ! is_installed 'Sublime Text' &>/dev/null;
then
  to_header "Installing Sublime Text..."
  brew cask install sublime-text
fi

## Brave Browser
if ! is_installed 'Brave Browser' &>/dev/null;
then
  to_header "Installing Brave Browser..."
  brew install --cask brave-browser
fi

## Slack
if ! is_installed 'Slack' &>/dev/null;
then
  to_header "Installing Slack..."
  brew install --cask slack
fi

## Obsidian
if ! is_installed 'Obsidian' &>/dev/null;
then
  to_header "Installing Obsidian..."
  brew install --cask obsidian
fi

## Spotify
if ! is_installed 'Spotify' &>/dev/null;
then
  to_header "Installing Spotify..."
  brew install --cask spotify
fi

## Update apps in dock
source macos/dock.sh


## Generate ssh key
if [[ set_git_config -eq 1 ]]; then
  to_header "Generating an ed25519 ssh key for GitHub"
  ssh-keygen -t ed25519 -C "jg.roac@gmail.com"
  echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_rsa" | tee ~/.ssh/config
  eval "$(ssh-agent -s)"
  echo "run 'pbcopy < ~/.ssh/id_rsa.pub' and paste that into GitHub"
fi

## Remove cloned dotfiles from system
if [ -d ~/dotfiles ]; then
  sudo rm -R ~/dotfiles
fi

echo "🚀  Thats all, Done. Please restart for some changes to take effect"
