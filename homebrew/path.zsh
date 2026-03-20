# Homebrew PATH setup

# Apple Silicon
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
  FPATH="/opt/homebrew/share/zsh-completions:$FPATH"
# Intel Mac
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
  FPATH="/usr/local/share/zsh-completions:$FPATH"
fi
