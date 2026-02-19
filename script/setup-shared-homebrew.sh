#!/usr/bin/env bash
# One-time setup: create /opt/homebrew-shared and install Homebrew there for shared use.
# Run as admin (sudo only for creating the dir; installer runs as you). Safe to run again (idempotent).

set -e
SHARED_PREFIX="${HOMEBREW_SHARED_PREFIX:-/opt/homebrew}"

if [ -x "$SHARED_PREFIX/bin/brew" ]; then
  echo "Shared Homebrew already at $SHARED_PREFIX."
  exit 0
fi

RUN_USER="${SUDO_USER:-$USER}"
if [ ! -d "$SHARED_PREFIX" ]; then
  # If /opt/homebrew doesn't exist, we can't easily install it in shared mode without initial setup.
  # But usually it exists.
  echo "Creating $SHARED_PREFIX (needs sudo)..."
  sudo mkdir -p "$SHARED_PREFIX"
  sudo chmod 755 "$SHARED_PREFIX"
  sudo chown "$RUN_USER:admin" "$SHARED_PREFIX"
  sudo chmod g+s "$SHARED_PREFIX"
else
  # Apply shared permissions to existing install
  echo "Applying shared permissions to existing $SHARED_PREFIX..."
  sudo chown -R "$RUN_USER:admin" "$SHARED_PREFIX"
  sudo chmod -R g+w "$SHARED_PREFIX"
  sudo chmod -R g+s "$SHARED_PREFIX"
fi

# Skip installation if brew already works
if [ ! -x "$SHARED_PREFIX/bin/brew" ]; then
  if [ -d "$SHARED_PREFIX/.git" ]; then
    echo "Completing existing clone in $SHARED_PREFIX..."
    (cd "$SHARED_PREFIX" && git fetch origin && git reset --hard origin/HEAD)
    [ -x "$SHARED_PREFIX/bin/brew" ] && "$SHARED_PREFIX/bin/brew" update --force
  else
    echo "Installing Homebrew into $SHARED_PREFIX (manual clone)..."
    # Ensure dir exists and has correct owner
    sudo mkdir -p "$SHARED_PREFIX"
    sudo chown "$RUN_USER:admin" "$SHARED_PREFIX"
    git clone https://github.com/Homebrew/brew "$SHARED_PREFIX"
    "$SHARED_PREFIX/bin/brew" update --force
  fi
fi

if [ ! -x "$SHARED_PREFIX/bin/brew" ]; then
  echo "Failed to install Homebrew at $SHARED_PREFIX." >&2
  exit 1
fi
echo "Shared Homebrew ready at $SHARED_PREFIX."
