#!/bin/sh
#
# Alfred configuration
# Links Alfred preferences from dotfiles and disables Spotlight shortcut

ALFRED_PREFS="$HOME/Library/Application Support/Alfred"
DOTFILES_PREFS="$HOME/dotfiles/alfred/Alfred.alfredpreferences"

if [ -d "/Applications/Alfred 5.app" ]; then
    echo ""
    echo "=== Alfred Configuration ==="
    
    # Disable Spotlight shortcut (Cmd+Space) to use Alfred instead
    echo "Disabling Spotlight shortcut..."
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:64:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:64:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    /usr/libexec/PlistBuddy -c "Set :AppleSymbolicHotKeys:65:enabled false" ~/Library/Preferences/com.apple.symbolichotkeys.plist 2>/dev/null || \
    /usr/libexec/PlistBuddy -c "Add :AppleSymbolicHotKeys:65:enabled bool false" ~/Library/Preferences/com.apple.symbolichotkeys.plist
    # Apply settings immediately
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    
    if [ -d "$DOTFILES_PREFS" ]; then
        # Create Alfred support directory if needed
        mkdir -p "$ALFRED_PREFS"
        
        # Backup existing preferences if not a symlink
        if [ -d "$ALFRED_PREFS/Alfred.alfredpreferences" ] && [ ! -L "$ALFRED_PREFS/Alfred.alfredpreferences" ]; then
            echo "Backing up existing Alfred preferences..."
            mv "$ALFRED_PREFS/Alfred.alfredpreferences" "$ALFRED_PREFS/Alfred.alfredpreferences.backup"
        fi
        
        # Create symlink
        if [ ! -L "$ALFRED_PREFS/Alfred.alfredpreferences" ]; then
            echo "Linking Alfred preferences from dotfiles..."
            ln -s "$DOTFILES_PREFS" "$ALFRED_PREFS/Alfred.alfredpreferences"
        fi
        
        # Get local hash for this Mac (Alfred generates this on first run)
        LOCAL_HASH=$(cat "$ALFRED_PREFS/prefs.json" 2>/dev/null | grep localhash | sed 's/.*: "\(.*\)".*/\1/')
        
        # If no local hash exists, start Alfred briefly to generate one
        if [ -z "$LOCAL_HASH" ]; then
            echo "Starting Alfred to generate local hash..."
            open -a "Alfred 5"
            sleep 3
            killall Alfred 2>/dev/null
            LOCAL_HASH=$(cat "$ALFRED_PREFS/prefs.json" 2>/dev/null | grep localhash | sed 's/.*: "\(.*\)".*/\1/')
        fi
        
        # If this Mac's hash doesn't exist in dotfiles, create symlink to main config
        MAIN_HASH="d05fb046086fa0f7268efc635c45555a69327ea0"
        if [ -n "$LOCAL_HASH" ] && [ "$LOCAL_HASH" != "$MAIN_HASH" ] && [ ! -d "$DOTFILES_PREFS/preferences/local/$LOCAL_HASH" ]; then
            echo "Creating local config symlink for this Mac..."
            ln -s "$DOTFILES_PREFS/preferences/local/$MAIN_HASH" "$DOTFILES_PREFS/preferences/local/$LOCAL_HASH"
        fi
        
        # Update prefs.json to point to the symlinked location
        echo "{
  \"current\" : \"$DOTFILES_PREFS\",
  \"localhash\" : \"$LOCAL_HASH\"
}" > "$ALFRED_PREFS/prefs.json"
        
        echo "Alfred preferences linked!"
        
        # Restart Alfred to apply settings
        killall Alfred 2>/dev/null
        open -a "Alfred 5"
    fi
    
    echo "Done! You may need to log out and back in for Spotlight shortcut change to take effect."
fi
