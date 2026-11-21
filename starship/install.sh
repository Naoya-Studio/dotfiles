#!/bin/sh
#
# Starship
#
# This creates the symlink for Starship config

STARSHIP_CONFIG_DIR="$HOME/.config"
DOTFILES_STARSHIP="$HOME/dotfiles/starship/starship.toml"

if [ -f "$DOTFILES_STARSHIP" ]; then
  mkdir -p "$STARSHIP_CONFIG_DIR"

  if [ -e "$STARSHIP_CONFIG_DIR/starship.toml" ] && [ ! -L "$STARSHIP_CONFIG_DIR/starship.toml" ]; then
    echo "  Backing up existing Starship config"
    mv "$STARSHIP_CONFIG_DIR/starship.toml" "$STARSHIP_CONFIG_DIR/starship.toml.backup"
  fi

  if [ ! -e "$STARSHIP_CONFIG_DIR/starship.toml" ]; then
    echo "  Linking Starship config"
    ln -s "$DOTFILES_STARSHIP" "$STARSHIP_CONFIG_DIR/starship.toml"
  fi
fi

exit 0
