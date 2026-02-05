#!/usr/bin/env bash
# Print raw GitHub URL for homebrew/allowed.txt (used so other Macs can fetch allowlist without dot shared).
set -e
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
cd "$DOTFILES"
branch=$(git branch --show-current)
remote=$(git remote get-url origin)
if [[ "$remote" =~ git@github.com:([^/]+)/([^/]+?)(\.git)?$ ]]; then
  echo "https://raw.githubusercontent.com/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}/$branch/homebrew/allowed.txt"
elif [[ "$remote" =~ https://github.com/([^/]+)/([^/]+?)(\.git)?$ ]]; then
  echo "https://raw.githubusercontent.com/${BASH_REMATCH[1]}/${BASH_REMATCH[2]}/$branch/homebrew/allowed.txt"
else
  exit 1
fi
