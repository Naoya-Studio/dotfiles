# System-wide PATH settings

# Dotfiles bin (dot, etc.)
export PATH="$HOME/dotfiles/bin:$PATH"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Cargo (Rust)
export PATH="$HOME/.cargo/bin:$PATH"

# LM Studio CLI
export PATH="$PATH:$HOME/.lmstudio/bin"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
