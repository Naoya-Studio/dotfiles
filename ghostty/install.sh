#!/bin/sh
#
# Ghostty
#
# This creates the symlink for Ghostty config

GHOSTTY_CONFIG_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
DOTFILES_GHOSTTY="$HOME/dotfiles/ghostty/config"

if [ -f "$DOTFILES_GHOSTTY" ]; then
  mkdir -p "$GHOSTTY_CONFIG_DIR"

  if [ -e "$GHOSTTY_CONFIG_DIR/config" ] && [ ! -L "$GHOSTTY_CONFIG_DIR/config" ]; then
    echo "  Backing up existing Ghostty config"
    mv "$GHOSTTY_CONFIG_DIR/config" "$GHOSTTY_CONFIG_DIR/config.backup"
  fi

  if [ ! -e "$GHOSTTY_CONFIG_DIR/config" ]; then
    echo "  Linking Ghostty config"
    ln -s "$DOTFILES_GHOSTTY" "$GHOSTTY_CONFIG_DIR/config"
  fi
fi

exit 0
