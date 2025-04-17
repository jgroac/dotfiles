#!/bin/bash

REPO_URL="https://github.com/jgroac/dotfiles"
CLONE_DIR="$HOME/dotfiles"

if [ -d "$CLONE_DIR" ]; then
  echo "⚠️  Dotfiles directory already exists at $CLONE_DIR"
else
  echo "📥 Cloning dotfiles..."
  git clone "$REPO_URL" "$CLONE_DIR"
fi

cd "$CLONE_DIR" || exit
bash install.sh
