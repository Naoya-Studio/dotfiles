#!/bin/sh
# Set sudo_local for Touch ID in tmux (pam_reattach + pam_tid). Requires: brew, pam-reattach.

set -e

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This script is for macOS only."
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install Homebrew first."
  exit 1
fi

PAM_REATTACH_PREFIX="$(brew --prefix pam-reattach 2>/dev/null || true)"
PAM_REATTACH_SRC="$PAM_REATTACH_PREFIX/lib/pam/pam_reattach.so"
PAM_REATTACH_TARGET="/usr/local/lib/pam/pam_reattach.so"

if [ -z "$PAM_REATTACH_PREFIX" ] || [ ! -f "$PAM_REATTACH_SRC" ]; then
  echo "pam_reattach not found. Install with: brew install pam-reattach"
  exit 1
fi

echo "Installing pam_reattach to a stable path..."
sudo mkdir -p "$(dirname "$PAM_REATTACH_TARGET")"
sudo install -m 644 "$PAM_REATTACH_SRC" "$PAM_REATTACH_TARGET"

echo "Configuring Touch ID for sudo in tmux (pam_reattach + pam_tid)..."
sudo tee /etc/pam.d/sudo_local > /dev/null <<EOF
# sudo_local: local config file which survives system update
auth       optional       $PAM_REATTACH_TARGET
auth       sufficient     pam_tid.so
EOF
echo "Done. Touch ID will work in tmux too."
