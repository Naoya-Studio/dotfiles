#!/bin/sh
#
# Homebrew
#
# This installs Homebrew if it's not already installed.

if test ! $(which brew)
then
  echo "  Installing Homebrew for you."

  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Set up PATH for this session
  if [[ $(uname -m) == "arm64" ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  else
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# Allow brew to run without password (for autoupdate)
if [ ! -f /etc/sudoers.d/brew ]; then
  echo "  Configuring passwordless sudo for brew..."
  if [[ $(uname -m) == "arm64" ]]; then
    BREW_PATH="/opt/homebrew/bin/brew"
  else
    BREW_PATH="/usr/local/bin/brew"
  fi
  echo "$USER ALL=(ALL) NOPASSWD: $BREW_PATH" | sudo tee /etc/sudoers.d/brew > /dev/null
  sudo chmod 440 /etc/sudoers.d/brew
fi

exit 0
