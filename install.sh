#!/bin/bash

source utils/logger.sh
source utils/helpers.sh

# source macos/defaults.sh

###############################################################################
# Git config                                                                  #
###############################################################################

to_header "Git config"

ask "${blue} Do you want to config git (y/n):"
gitConfig=$(prompt_confirm)

cp .gitignore ~/.gitignore_global  ## Adding .gitignore global
git config --global core.excludesfile "${HOME}/.gitignore_global"

if [[ gitConfig -eq 1 ]]; then
  ask "${blue} Git email:"
  read -r emailId
fi

if is_empty $emailId; then
  git config --global user.email "$emailId" ## Git Email Id
  to_success "Email is set"
else
  to_warning "Not set"
fi

if [[ gitConfig -eq 1 ]]; then
  ask "${blue} Git username:"
  read -r userName
fi

if is_empty $userName; then
  git config --global user.name "$userName" ## Git Username
  to_success "Username is set"
else
  to_warning "Not set"
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
# Terminal                                                                    #
###############################################################################

if ! isInstalled 'iTerm' &>/dev/null;
then
  to_header "Installing iTerm..."
  brew install --cask iterm2
fi

if ! isInstalled 'Alacritty' &>/dev/null;
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
# Node                                                                        #
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


###############################################################################
# Tools                                                                       #
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


## git-delta
if ! type delta > /dev/null
then
  to_header "Installing git-delta..."
  # brew install git-delta
  git config --global core.pager "delta --plus-color=\"#012800\" --minus-color=\"#340001\" --theme=\"night-owlish\""
  git config --global interactive.diffFilter "delta --color-only"
fi

## Vscode
if ! isInstalled 'Visual Studio Code' &>/dev/null;
then
  to_header "Installing Visual Studio Code..."
  brew cask install visual-studio-code
fi


## Sublime
if ! isInstalled 'Sublime Text' &>/dev/null;
then
  to_header "Installing Sublime Text..."
  brew cask install sublime-text
fi

## Brave Browser
if ! isInstalled 'Brave Browser' &>/dev/null;
then
  to_header "Installing Brave Browser..."
  brew install --cask brave-browser
fi

## Slack
if ! isInstalled 'Slack' &>/dev/null;
then
  to_header "Installing Slack..."
  brew install --cask slack
fi

## Obsidian
if ! isInstalled 'Obsidian' &>/dev/null;
then
  to_header "Installing Obsidian..."
  brew install --cask obsidian
fi

## Spotify
if ! isInstalled 'Spotify' &>/dev/null;
then
  to_header "Installing Spotify..."
  brew install --cask spotify
fi

## Update apps in dock
source macos/dock.sh


to_header "Generating an ed25519 token for GitHub"
ssh-keygen -t ed25519 -C "jg.roac@gmail.com"
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_rsa" | tee ~/.ssh/config
eval "$(ssh-agent -s)"
echo "run 'pbcopy < ~/.ssh/id_rsa.pub' and paste that into GitHub"

## Remove cloned dotfiles from system
if [ -d ~/dotfiles ]; then
  sudo rm -R ~/dotfiles
fi

echo "🍺  Thats all, Done. Please restart for some changes to take effect"
