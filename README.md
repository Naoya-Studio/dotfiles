# naoya's dotfiles

Personal dotfiles for macOS, inspired by [holman/dotfiles](https://github.com/holman/dotfiles).

---

## Quick start

| Option | One-liner | What it does |
|--------|-----------|--------------|
| **Full** | `bash -c "$(curl -fsSL https://raw.githubusercontent.com/Naoya-Studio/dotfiles/main/script/setup)" -- full` | Xcode CLT → license → Homebrew → gh auth → clone this repo → bootstrap (symlinks + install) |
| **Core** | `bash -c "$(curl -fsSL https://raw.githubusercontent.com/Naoya-Studio/dotfiles/main/script/setup)" -- core` | Same up to clone, then quickstart (Alfred + shell + tmux + Touch ID). Later: `cd ~/dotfiles && brew bundle` for full |

**Other** (none of these use this repo; standalone commands only)

| Option | Command | What it does |
|--------|---------|--------------|
| **Homebrew only** | `bash -c "$(curl -fsSL https://raw.githubusercontent.com/Naoya-Studio/dotfiles/main/script/install-homebrew-only)"` | Xcode CLT → license → Homebrew only (no clone, no gh). Adds brew to `~/.zprofile`. |
| **Alfred** | `brew install --cask alfred` then set Cmd+Space in System Settings, disable Spotlight shortcut | Install Alfred, assign Cmd+Space, turn off Spotlight Cmd+Space. |
| **Git** | `git config --global user.name "..."` / `user.email "..."` | Set Git name and email. |
| **macOS defaults** | `defaults write -g ApplePressAndHoldEnabled -bool false` etc. | Key repeat, Finder, etc. Touch ID for sudo needs PAM separately. |
| **GitHub CLI** | `brew install gh` then `gh auth login` | Install gh and authenticate. |
| **Ghostty** | `brew install --cask ghostty` | Install Ghostty; config in app or `~/.config/ghostty/config`. |

---

## What you get

- **Homebrew** — packages, casks, mas (see `Brewfile`); autoupdate every 24h; passwordless sudo for brew
- **macOS** — Touch ID for sudo (tmux OK), key repeat, Finder, etc.
- **Alfred** — Cmd+Space, Spotlight off, prefs in dotfiles
- **Shell** — zsh, starship, PATH in `system/path.zsh` (includes `~/dotfiles/bin` so `dot` works)

---

## Daily use

**Update everything** (pull, brew, installers, macOS defaults):

```sh
dot
```

**Sync current state to GitHub** (Brewfile + all changes, commit & push):

```sh
dot --update
```

**Install from Brewfile:**

```sh
brew bundle
```

**Open dotfiles in editor:**

```sh
dot --edit
```

**First time after clone (or manual install):**

```sh
./script/bootstrap   # Symlinks + run installers
# or
./script/install     # Run installers only (no symlinks)
```

---

## Reference

### Directory layout

```
dotfiles/
├── bin/dot              # dot, dot --update, dot --edit
├── script/
│   ├── setup            # One-liner entry (full / core)
│   ├── install-homebrew-only
│   ├── bootstrap        # Symlinks + dot
│   ├── install          # All install.sh + brew bundle + set-defaults
│   └── suggest-commit   # Used by dot --update for commit message
├── homebrew/            # Homebrew install, autoupdate
├── macos/               # set-defaults (Touch ID, Finder, etc.)
├── alfred/              # Alfred prefs + install
├── git/, github/        # Git & gh config
├── ghostty/, tmux/, zsh/
├── system/              # PATH, env
└── Brewfile
```

### Run installers individually

```sh
./homebrew/install.sh   # Homebrew + passwordless sudo for brew
./macos/set-defaults.sh  # macOS + Touch ID for sudo
./alfred/install.sh     # Alfred + Spotlight off
./git/install.sh        # Git user (name/email); --force to reconfigure
./github/install.sh     # gh auth
./ghostty/install.sh    # Ghostty config
```

### How dotfiles are loaded

- **Symlinks** — `*.symlink` → `~/.filename` (e.g. `zshrc.symlink` → `~/.zshrc`)
- **PATH** — `system/path.zsh` adds `~/dotfiles/bin` (and others); loaded from zshrc
- **Install scripts** — `script/install` runs every `*/install.sh`

---

## Troubleshooting

### sudo: unable to initialize PAM (after uninstalling Homebrew)

Before uninstalling: `./script/pre-uninstall-homebrew`.  
If already broken: delete `/etc/pam.d/sudo_local` in Recovery Mode.

### Spotlight still Cmd+Space

Log out/in, or:

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

Or open a new terminal (if you used install-homebrew-only, it’s in `~/.zprofile`).
