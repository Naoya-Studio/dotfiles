# Naoya's dotfiles

Personal dotfiles for macOS, inspired by [holman/dotfiles](https://github.com/holman/dotfiles).

---

## Quick start

**Full** (Xcode CLT → license → Homebrew → gh auth → clone this repo → bootstrap):

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Naoya-Studio/dotfiles/main/script/setup)"
```

<details>
<summary><strong>Other</strong></summary>

Same URL; pass one or more modes (no space after `--`): `--core`, `--homebrew`, `--alfred`, `--git`, `--macos`, `--tmux`, `--github`, `--ghostty`. Multiple run in order: homebrew → git → github → ...

| Option | Command | What it does |
|--------|---------|--------------|
| **Core** | `... --core` | Same up to clone, then quickstart (Alfred + shell + tmux + Touch ID). Later: `cd ~/dotfiles && brew bundle` for full. |
| **Homebrew only** | `... --homebrew` | Xcode CLT → license → Homebrew only (no clone, no gh). Adds brew to `~/.zprofile`. |
| **Alfred** | `... --alfred` | Clone repo if needed, then run `alfred/install.sh` (Alfred + Cmd+Space, Spotlight off). |
| **Git** | `... --git` | Prompt for name/email and set `git config --global`. No Homebrew required. |
| **macOS** | `... --macos` | Curl and run `macos/set-defaults.sh` (Touch ID for sudo, key repeat, Finder). No clone. |
| **Tmux** | `... --tmux` | `brew install tmux pam-reattach`, then set sudo_local so Touch ID works in tmux. |
| **GitHub CLI** | `... --github` | Install gh if needed, run `gh auth login`. |
| **Ghostty** | `... --ghostty` | `brew install --cask ghostty`. Config in app or `~/.config/ghostty/config`. |

Examples: `... --github --homebrew` (run both); `... --alfred --macos` (clone then alfred, then macos). Use the full curl URL in place of `...`.

</details>

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

**Sync current state to GitHub** (Brewfile + all changes, commit & push; pulls remote first):

```sh
dot update
```

**Force pull** (discard local changes, match remote):

```sh
dot pull
```

**Allow other Mac users to brew install** (allowlist only; your Brewfile stays yours). Run once as admin (uses sudo):

```sh
dot shared
```

- **Add/remove:** `dot shared add 1password` (checks with `brew info` and adds formula or cask), `dot shared add --cask` / `--formula` to force type, `dot shared remove <name>`, `dot shared list`. Then run `dot shared` to deploy. The deployed allowlist is read-only (chmod 444).
- **Check:** `brew allowed` (any user) shows what’s allowed. Other users run `brew install <name>`; only allowlisted names succeed. Installs go to `/opt/homebrew-shared`.

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
├── bin/dot              # dot, dot update, dot pull, dot shared
├── script/
│   ├── setup            # One-liner entry (full / core)
│   ├── install-homebrew-only
│   ├── bootstrap        # Symlinks + dot
│   ├── install          # All install.sh + brew bundle + set-defaults
│   ├── suggest-commit   # Used by dot update for commit message
│   ├── dot-brew-install # Allowlist check + install to /opt/homebrew-shared
│   └── setup-shared-homebrew.sh  # One-time: create shared Homebrew prefix
├── homebrew/            # Homebrew install, autoupdate, allowed.txt (allowlist for dot shared)
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
eval "
$(/opt/homebrew/bin/brew shellenv)"
```

Or open a new terminal (if you used install-homebrew-only, it’s in `~/.zprofile`).