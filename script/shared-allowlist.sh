#!/usr/bin/env bash
# Manage homebrew/allowed.txt: add (with brew search check), remove, list.
# Usage: shared-allowlist.sh add [--cask|--formula] NAME
#        shared-allowlist.sh remove NAME
#        shared-allowlist.sh list

set -e
DOTFILES="${DOTFILES:-$HOME/dotfiles}"
ALLOWED="$DOTFILES/homebrew/allowed.txt"

subcmd="${1:-}"
shift || true

case "$subcmd" in
  list)
    [ ! -f "$ALLOWED" ] && echo "No $ALLOWED" && exit 1
    echo "Allowed (brew install for other users):"
    grep -v '^#' "$ALLOWED" | grep -v '^[[:space:]]*$' | sed 's/^/  /'
    ;;
  remove)
    name="$1"
    [ -z "$name" ] && echo "Usage: dot shared remove <name>" >&2 && exit 1
    [ ! -f "$ALLOWED" ] && echo "No $ALLOWED" && exit 1
    if grep -qE "^brew $name$|^cask $name$" "$ALLOWED"; then
      grep -vE "^brew $name$|^cask $name$" "$ALLOWED" > "$ALLOWED.tmp"
      mv "$ALLOWED.tmp" "$ALLOWED"
      echo "Removed: $name"
    else
      echo "Not in allowlist: $name" >&2
      exit 1
    fi
    ;;
  add)
    force_cask=false
    force_formula=false
    while [ $# -gt 0 ]; do
      case "$1" in
        --cask)     force_cask=true; shift ;;
        --formula)  force_formula=true; shift ;;
        *)          break ;;
      esac
    done
    name="$1"
    [ -z "$name" ] && echo "Usage: dot shared add [--cask|--formula] <name>" >&2 && exit 1

    # Check if already in allowlist
    if grep -qE "^brew $name$|^cask $name$" "$ALLOWED" 2>/dev/null; then
      echo "Already in allowlist: $name"
      exit 0
    fi

    # Resolve formula vs cask: use brew info to verify package exists
    if [ "$force_cask" = true ]; then
      if brew info --cask "$name" &>/dev/null; then
        line="cask $name"
      else
        echo "Not found as cask: $name (run: brew search --cask $name)" >&2
        exit 1
      fi
    elif [ "$force_formula" = true ]; then
      if brew info "$name" &>/dev/null; then
        line="brew $name"
      else
        echo "Not found as formula: $name (run: brew search $name)" >&2
        exit 1
      fi
    else
      in_cask=false
      in_formula=false
      brew info --cask "$name" &>/dev/null && in_cask=true
      brew info "$name" &>/dev/null && in_formula=true
      if [ "$in_cask" = true ] && [ "$in_formula" = false ]; then
        line="cask $name"
      elif [ "$in_formula" = true ] && [ "$in_cask" = false ]; then
        line="brew $name"
      elif [ "$in_cask" = true ] && [ "$in_formula" = true ]; then
        line="cask $name"
        echo "Found as both formula and cask; added as cask. Use 'dot shared add --formula $name' for formula."
      else
        echo "Not found in Homebrew: $name (run: brew search $name, brew search --cask $name)" >&2
        exit 1
      fi
    fi

    echo "$line" >> "$ALLOWED"
    echo "Added: $line (run 'dot shared' to deploy)"
    ;;
  *)
    echo "Usage: dot shared add [--cask|--formula] <name> | dot shared remove <name> | dot shared list" >&2
    exit 1
    ;;
esac
