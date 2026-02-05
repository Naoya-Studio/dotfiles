#!/usr/bin/env bash
# Print raw GitHub URL for homebrew/allowed.txt (used so other Macs can fetch allowlist without dot shared).
set -e
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
cd "$DOTFILES"
branch=$(git branch --show-current)
remote=$(git remote get-url origin)
# git@github.com:user/repo.git or https://github.com/user/repo[.git]
url=""
if [[ "$remote" == git@github.com:* ]]; then
  user=$(echo "$remote" | sed -n 's|git@github.com:\([^/]*\)/.*|\1|p')
  repo=$(echo "$remote" | sed 's|\.git$||' | sed -n 's|.*/||p')
  url="https://raw.githubusercontent.com/$user/$repo/$branch/homebrew/allowed.txt"
elif [[ "$remote" == https://github.com/* ]]; then
  user=$(echo "$remote" | sed -n 's|https://github.com/\([^/]*\)/.*|\1|p')
  repo=$(echo "$remote" | sed 's|\.git$||' | sed -n 's|.*/||p')
  url="https://raw.githubusercontent.com/$user/$repo/$branch/homebrew/allowed.txt"
fi
[ -n "$url" ] && echo "$url" || exit 1
