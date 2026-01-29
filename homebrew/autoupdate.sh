#!/bin/sh
#
# Homebrew autoupdate
# Run this after brew bundle finishes.

set -e

if ! command -v brew >/dev/null 2>&1; then
  exit 0
fi

mkdir -p "$HOME/Library/LaunchAgents"

# Ensure `brew autoupdate` command exists (provided by the tap)
brew tap homebrew/autoupdate >/dev/null 2>&1 || true

if brew autoupdate status 2>/dev/null | grep -q "running"; then
  exit 0
fi

echo "  Enabling Homebrew autoupdate..."
brew autoupdate start --upgrade --cleanup

