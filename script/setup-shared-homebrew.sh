#!/usr/bin/env bash
# One-time setup: create /opt/homebrew-shared and install Homebrew there for shared use.
# Run as admin (sudo only for creating the dir; installer runs as you). Safe to run again (idempotent).

set -e
SHARED_PREFIX="${HOMEBREW_SHARED_PREFIX:-/opt/homebrew-shared}"

if [ -x "$SHARED_PREFIX/bin/brew" ]; then
  echo "Shared Homebrew already at $SHARED_PREFIX."
  exit 0
fi

RUN_USER="${SUDO_USER:-$USER}"
if [ ! -d "$SHARED_PREFIX" ]; then
  echo "Creating $SHARED_PREFIX (needs sudo)..."
  sudo mkdir -p "$SHARED_PREFIX"
  sudo chmod 755 "$SHARED_PREFIX"
  sudo chown "$RUN_USER:staff" "$SHARED_PREFIX"
fi

if [ ! -x "$SHARED_PREFIX/bin/brew" ]; then
  echo "Installing Homebrew into $SHARED_PREFIX..."
  HOMEBREW_PREFIX="$SHARED_PREFIX" HOMEBREW_REPOSITORY="$SHARED_PREFIX" \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ ! -x "$SHARED_PREFIX/bin/brew" ]; then
  echo "Failed to install Homebrew at $SHARED_PREFIX." >&2
  exit 1
fi
echo "Shared Homebrew ready at $SHARED_PREFIX."
