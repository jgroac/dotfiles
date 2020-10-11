#!/bin/bash

# Welcome!!
# Custom dotfiles to get you started with OS X machine for development.
# Authors:
# https://github.com/gokulkrishh
# https://github.com/jgroac
# Source: https://github.com/jgroac/dotfiles

## Custom color codes & utility functions
source helper/utility.sh

## Terminal & Dock setup
source osx/screen.sh
source osx/dock.sh
source osx/system.sh
source osx/terminal.sh

# Welcome msg

e_bold "${tan}┌──────────────────────────────────────────────────────────────┐
|                                                              |
| Welcome!!                                                    |
|                                                              |
| Setup your OS X machine for web development at ease.         |
|                                                              |
|                                                              |
└──────────────────────────────────────────────────────────────┘"

# 1. Git configuration

e_header "Setup git config (global)"
cp gitignore ~/.gitignore_global  ## Adding .gitignore global
git config --global core.excludesfile "${HOME}/.gitignore_global"

ask "${blue} (Option) Enter Your Github Email: "
read -r emailId
if is_empty $emailId; then
  git config --global user.email "$emailId" ## Git Email Id
  e_success "Email is set"
else
  e_error "Not set"
fi

ask "${blue} (Option) Enter Your Github Username: "
read -r userName
if is_empty $userName; then
  git config --global user.name "$userName" ## Git Username
  e_success "Username is set"
else
  e_error "Not set"
fi

# 2. Install Oh-My-Zsh & custom aliases

ZSH=~/.oh-my-zsh

if [ -d "$ZSH" ]; then
  e_warning "Oh My Zsh is already installed. Skipping.."
else
  e_header "Installing Oh My Zsh..."
  curl -L http://install.ohmyz.sh | sh

  ## To install ZSH themes & aliases
  e_header "Copying ZSH themes & aliases..."
  e_note "Check .aliases file for more details."
  cp oh-my-zsh/aliases ~/.aliases                                        ## Copy aliases
  cp oh-my-zsh/zshrc ~/.zshrc                                            ## Copy zshrc configs
  cp oh-my-zsh/z.sh ~/z.sh                                               ## Copy z.sh autocompletion file
  git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k ## zsh theme
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ## Copy syntax higlighting pluging
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ## Copy autosuggestions pluging
fi

## Create codelabs & workspace directory
mkdir codelabs
mkdir workspace

# 3. Install Homebrew

if test ! $(which brew); then
  e_header "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
  e_warning "Homebrew is already installed. Skipping.."
fi

# 4. Install ZSH NVM

if test ! $(which nvm); then
  e_header "Installing zsh-nvm.."

  git clone https://github.com/lukechilds/zsh-nvm ~/.oh-my-zsh/custom/plugins/zsh-nvm

  ## To setup npm install/update -g without sudo
  cp npmrc ~/.npmrc
  mkdir "${HOME}/.npm-packages"
  export PATH="$HOME/.node/bin:$PATH"
  sudo chown -R $(whoami) $(npm config get prefix)/{lib/node_modules,bin,share}

  ## Set npm global config
  npm config set init.author.name "Jose Roa"
  npm config set init.author.email "jg.roac@gmail.com"
else
  e_warning "NVM is already installed. Skipping.."
fi

## Yarn install
if ! type yarn > /dev/null
then
  e_header "Install yarn.."
  brew install yarn
fi

## Print installed node, npm version
echo "node --version: $(node --version)"
echo "npm --version: $(npm --version)"


# My touchbar. My rules
if ! whichapp 'MTMR' &>/dev/null;
then
  e_header "Install My touchbar. My rules.."
  brew cask install mtmr
  cp -rf osx/items.json ~/Library/Application\ Support/MTMR/items.json
fi

# Serve static files
if ! type serve > /dev/null
then
  e_header "Install serve.."
  yarn global add serve
fi

## thefuck install
if ! type fuck > /dev/null
then
  e_header "Install thefuck.."
  brew install thefuck
fi


## Bat install
if ! type bat > /dev/null
then
  e_header "Install bat.."
  brew install bat

  e_header "Install bat themes.."
  mkdir -p "$(bat --config-dir)/themes"
  cd "$(bat --config-dir)/themes"

  # Download a theme in '.tmTheme' format, for example:
  git clone https://github.com/batpigandme/night-owlish

  # Update the binary cache
  bat cache --build
fi


## Ripgrep install
if ! type rg > /dev/null
then
  e_header "Install ripgrep.."
  brew install ripgrep
fi


## git-delta install
if ! type delta > /dev/null
then
  e_header "Install git-delta.."
  # brew install git-delta
  git config --global core.pager "delta --plus-color=\"#012800\" --minus-color=\"#340001\" --theme=\"night-owlish\""
  git config --global interactive.diffFilter "delta --color-only"
fi

## Vscode install
if ! whichapp 'Visual Studio Code' &>/dev/null;
then
  e_header "Install Visual Studio Code"
  brew cask install visual-studio-code
fi

## Sublime install
if ! whichapp 'Sublime Text' &>/dev/null;
then
  e_header "Install Sublime Text"
  brew cask install sublime-text
fi

echo "Generating an RSA token for GitHub"
ssh-keygen -t rsa -b 4096 -C "jg.roac@gmail.com"
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_rsa" | tee ~/.ssh/config
eval "$(ssh-agent -s)"
echo "run 'pbcopy < ~/.ssh/id_rsa.pub' and paste that into GitHub"

## Remove cloned dotfiles from system
if [ -d ~/dotfiles ]; then
  sudo rm -R ~/dotfiles
fi

echo "🍺  Thats all, Done. Note that some of these changes require a logout/restart to take effect."

# END
