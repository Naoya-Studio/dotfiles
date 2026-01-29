#!/bin/sh
#
# Git configuration setup
# Prompts for user info on first run
# Usage: ./install.sh [--force]

FORCE=false
if [ "$1" = "--force" ] || [ "$1" = "-f" ]; then
    FORCE=true
fi

echo ""
echo "=== Git Configuration ==="

current_name=$(git config --global user.name)
current_email=$(git config --global user.email)

# If both are set and not forcing, skip
if [ -n "$current_name" ] && [ -n "$current_email" ] && [ "$FORCE" = false ]; then
    echo "Git user already configured: $current_name <$current_email>"
    echo "Run with --force to reconfigure"
    exit 0
fi

# Try to get defaults from gh if authenticated
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
    default_name=$(gh api user --jq '.name' 2>/dev/null)
    default_email=$(gh api user --jq '.email' 2>/dev/null)
fi

# Use current values as defaults if set
[ -n "$current_name" ] && default_name=$current_name
[ -n "$current_email" ] && default_email=$current_email

# Prompt for name if not set or forcing
if [ -z "$current_name" ] || [ "$FORCE" = true ]; then
    printf "Git user name"
    [ -n "$default_name" ] && printf " [$default_name]"
    printf ": "
    read user_name
    user_name=${user_name:-$default_name}

    if [ -n "$user_name" ]; then
        git config --global user.name "$user_name"
        echo "Set git user.name to: $user_name"
    fi
fi

# Prompt for email if not set or forcing
if [ -z "$current_email" ] || [ "$FORCE" = true ]; then
    printf "Git user email"
    [ -n "$default_email" ] && printf " [$default_email]"
    printf ": "
    read user_email
    user_email=${user_email:-$default_email}

    if [ -n "$user_email" ]; then
        git config --global user.email "$user_email"
        echo "Set git user.email to: $user_email"
    fi
fi

echo "Git configuration complete!"
