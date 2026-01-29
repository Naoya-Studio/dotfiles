#!/bin/sh
#
# Sets reasonable macOS defaults.
#
# Run ./set-defaults.sh and you'll be good to go.
# Some settings may require a logout/restart to take effect.

# Disable press-and-hold for keys in favor of key repeat
defaults write -g ApplePressAndHoldEnabled -bool false

# Set a really fast key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Always open everything in Finder's list view
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show the ~/Library folder
chflags nohidden ~/Library

# Show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar in Finder
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Set the Finder prefs for showing a few different volumes on the Desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Use AirDrop over every interface
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# Enable Touch ID for sudo (works in tmux too with pam-reattach)
if grep -q pam_tid /etc/pam.d/sudo_local 2>/dev/null; then
    echo "Touch ID for sudo is already configured in sudo_local"
else
    # Determine pam_reattach.so path based on architecture
    if [ "$(uname -m)" = "arm64" ]; then
        PAM_REATTACH="/opt/homebrew/lib/pam/pam_reattach.so"
    else
        PAM_REATTACH="/usr/local/lib/pam/pam_reattach.so"
    fi

    # Only configure if pam_reattach.so is installed (requires Homebrew)
    if [ -f "$PAM_REATTACH" ]; then
        echo "Configuring Touch ID for sudo..."
        # Create sudo_local with pam_reattach and pam_tid
        sudo tee /etc/pam.d/sudo_local > /dev/null <<EOF
# sudo_local: local config file which survives system update
auth       optional       $PAM_REATTACH
auth       sufficient     pam_tid.so
EOF
        echo "Touch ID for sudo has been enabled"
    else
        echo "Skipping Touch ID for sudo (pam-reattach not installed yet)"
    fi
fi

echo "Done. Note that some of these changes require a logout/restart to take effect."
