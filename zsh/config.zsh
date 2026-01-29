# Initialize starship prompt
eval "$(starship init zsh)"

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# pyenv
if command -v pyenv &>/dev/null; then
  eval "$(pyenv init --path)"
fi
