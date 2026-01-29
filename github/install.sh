#!/bin/sh
#
# GitHub CLI configuration setup
# Prompts for authentication if not logged in

echo ""
echo "=== GitHub CLI Configuration ==="

if ! command -v gh &> /dev/null; then
    echo "gh is not installed. Run 'brew install gh' first."
    exit 0
fi

if gh auth status &> /dev/null; then
    echo "GitHub CLI already authenticated: $(gh api user --jq '.login' 2>/dev/null)"
else
    echo "GitHub CLI is not authenticated."
    printf "Would you like to login now? [Y/n]: "
    read answer
    answer=${answer:-Y}
    
    if [ "$answer" = "Y" ] || [ "$answer" = "y" ]; then
        gh auth login
    else
        echo "Skipped. Run 'gh auth login' later to authenticate."
    fi
fi
