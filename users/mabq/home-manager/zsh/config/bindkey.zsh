# -- Use vi mode instead of emacs (default)
bindkey -v

# -- Zsh bug fix
#    https://github.com/spaceship-prompt/spaceship-prompt/issues/91#issuecomment-327996599
bindkey '^?' backward-delete-char

# -- Launch tmux-sessionizer
bindkey -s '^s' "$HOME/.local/bin/tmux-sessionizer\n"

# -- History search up/down arrows
#    Requires zsh-history-substring-search plugin.
#    Disabled because we are now using Atuin.
# bindkey '^[[A' history-substring-search-up    # up arrow
# bindkey '^[[B' history-substring-search-down  # donw arrow

