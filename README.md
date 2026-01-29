# naoya's dotfiles

Personal dotfiles for macOS, inspired by [holman/dotfiles](https://github.com/holman/dotfiles).

## New Mac Setup (One-liner)

```sh
curl -fsSL https://raw.githubusercontent.com/Naoya-Studio/dotfiles/main/script/setup -o /tmp/setup.sh && bash /tmp/setup.sh
```

This will:
1. Install Xcode Command Line Tools
2. Accept Xcode license
3. Install Homebrew
4. Install & authenticate GitHub CLI
5. Clone this repo
6. Run bootstrap (install all apps, configure macOS, etc.)

## What Gets Installed

- **Homebrew packages**: See `Brewfile`
- **Mac App Store apps**: Via `mas` in `Brewfile`
- **VS Code extensions**: Via `vscode` in `Brewfile`
- **macOS settings**: Touch ID for sudo, key repeat, Finder settings, etc.
- **Alfred**: With Cmd+Space hotkey and synced preferences
- **Shell**: zsh with starship prompt

## Commands

### Initial Setup
```sh
./script/bootstrap     # Full setup (symlinks + install)
./script/install       # Run installers only
```

### Maintenance
```sh
dot                    # Update everything (pull, brew update, etc.)
brew bundle            # Install apps from Brewfile
brew bundle cleanup --force  # Remove apps not in Brewfile
brew bundle dump --force     # Update Brewfile with current apps
```

### Individual Installers
```sh
./homebrew/install.sh  # Homebrew + autoupdate + passwordless sudo
./macos/set-defaults.sh # macOS settings + Touch ID for sudo
./alfred/install.sh    # Alfred preferences + Spotlight disable
./git/install.sh       # Git user config (prompts for name/email)
./github/install.sh    # GitHub CLI authentication
./ghostty/install.sh   # Ghostty terminal config
```

### Git Config
```sh
./git/install.sh         # First time setup (prompts)
./git/install.sh --force # Reconfigure
```

## Structure

```
dotfiles/
├── alfred/              # Alfred preferences & install
├── bin/dot              # Maintenance script
├── Brewfile             # Homebrew packages, casks, mas apps
├── ghostty/             # Ghostty terminal config
├── git/                 # Git config & install
├── github/              # GitHub CLI install
├── homebrew/            # Homebrew install & autoupdate
├── macos/               # macOS settings (Touch ID, etc.)
├── script/
│   ├── bootstrap        # Initial setup
│   ├── install          # Run installers
│   └── setup            # One-liner setup script
├── system/              # PATH & environment
├── tmux/                # tmux config
└── zsh/                 # zsh config
```

## Components

- **topic/*.zsh**: Loaded into shell environment
- **topic/path.zsh**: Loaded first, sets up `$PATH`
- **topic/install.sh**: Executed by `script/install`
- **topic/*.symlink**: Symlinked to `$HOME` (without `.symlink` extension)

## Features

### Touch ID for sudo
Works in tmux too (via `pam-reattach`). Configured automatically.

### Homebrew Autoupdate
Auto-updates every 24 hours. Passwordless sudo for brew.
(Enabled after `brew bundle` via the `homebrew/autoupdate` tap.)

### Alfred
- Cmd+Space hotkey (Spotlight disabled)
- Preferences synced across Macs

### Git
- User config prompted on first run
- Reconfigure with `./git/install.sh --force`

## Troubleshooting

### Spotlight still responds to Cmd+Space
Log out and back in, or:
```sh
killall cfprefsd
killall SystemUIServer
```

### Alfred settings not applied
```sh
killall Alfred
./alfred/install.sh
```

### brew command not found
```sh
eval "$(/opt/homebrew/bin/brew shellenv)"
```
