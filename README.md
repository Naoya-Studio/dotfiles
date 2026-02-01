# naoya's dotfiles

Personal dotfiles for macOS, inspired by [holman/dotfiles](https://github.com/holman/dotfiles).

---

## Quick start

| Option | One-liner | What it does |
|--------|-----------|--------------|
| **Full** | `bash -c "$(curl -fsSL https://raw.githubusercontent.com/Naoya-Studio/dotfiles/main/script/setup)" -- full` | Xcode CLT → license → Homebrew → gh auth → clone this repo → bootstrap (symlinks + install) |
| **Core** | `bash -c "$(curl -fsSL https://raw.githubusercontent.com/Naoya-Studio/dotfiles/main/script/setup)" -- core` | Same up to clone, then quickstart (Alfred + shell + tmux + Touch ID). Later: `cd ~/dotfiles && brew bundle` for full |

<details>
<summary><strong>その他</strong>（いずれもこのリポジトリは使わない）</summary>

**Homebrew only**

Xcode CLT → license → Homebrew だけ（clone なし、gh なし）。`~/.zprofile` に brew を追加。curl でスクリプト取得のみ。

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Naoya-Studio/dotfiles/main/script/install-homebrew-only)"
```

**Alfred 設定**

Alfred を入れて Cmd+Space に。Spotlight はシステム環境設定 → キーボード → ショートカットで無効化。

```sh
brew install --cask alfred
# システム環境設定で Cmd+Space を Alfred に割り当て、Spotlight の Cmd+Space をオフ
```

**Git 設定**（name / email）

```sh
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

**macOS 設定**（キーリピート、Finder など。Touch ID for sudo は別途 PAM 設定が必要）

```sh
defaults write -g ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write com.apple.Finder FXPreferredViewStyle Nlsv
# 反映には再ログインや killall Finder が必要な場合あり
```

**GitHub CLI 認証**

```sh
brew install gh
gh auth login
```

**Ghostty 設定**

Ghostty を入れたあと、設定はアプリ内または `~/.config/ghostty/config` を編集。

```sh
brew install --cask ghostty
```
</details>

---

<details>
<summary><strong>What you get</strong></summary>

- **Homebrew** — packages, casks, mas (see `Brewfile`); autoupdate every 24h; passwordless sudo for brew
- **macOS** — Touch ID for sudo (tmux OK), key repeat, Finder, etc.
- **Alfred** — Cmd+Space, Spotlight off, prefs in dotfiles
- **Shell** — zsh, starship, PATH in `system/path.zsh` (includes `~/dotfiles/bin` so `dot` works)
</details>

---

<details>
<summary><strong>Daily use</strong></summary>

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
</details>

---

<details>
<summary><strong>Reference</strong></summary>

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
./macos/set-defaults.sh   # macOS + Touch ID for sudo
./alfred/install.sh      # Alfred + Spotlight off
./git/install.sh         # Git user (name/email); --force to reconfigure
./github/install.sh      # gh auth
./ghostty/install.sh     # Ghostty config
```

### How dotfiles are loaded

- **Symlinks** — `*.symlink` → `~/.filename` (e.g. `zshrc.symlink` → `~/.zshrc`)
- **PATH** — `system/path.zsh` adds `~/dotfiles/bin` (and others); loaded from zshrc
- **Install scripts** — `script/install` runs every `*/install.sh`
</details>

---

<details>
<summary><strong>Troubleshooting</strong></summary>

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
</details>
