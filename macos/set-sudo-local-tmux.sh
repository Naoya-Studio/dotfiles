#!/bin/sh
# Set sudo_local for Touch ID in tmux (pam_reattach + pam_tid). Requires: brew, pam-reattach.

set -e

if [ "$(uname -s)" != "Darwin" ]; then
  echo "This script is for macOS only."
  exit 1
fi

if [ "$(uname -m)" = "arm64" ]; then
  PAM_REATTACH="/opt/homebrew/lib/pam/pam_reattach.so"
else
  PAM_REATTACH="/usr/local/lib/pam/pam_reattach.so"
fi

if [ ! -f "$PAM_REATTACH" ]; then
  echo "pam_reattach not found. Install with: brew install pam-reattach"
  exit 1
fi

echo "Configuring Touch ID for sudo in tmux (pam_reattach + pam_tid)..."
sudo tee /etc/pam.d/sudo_local > /dev/null <<EOF
# sudo_local: local config file which survives system update
auth       optional       $PAM_REATTACH
auth       sufficient     pam_tid.so
EOF
echo "Done. Touch ID will work in tmux too."
