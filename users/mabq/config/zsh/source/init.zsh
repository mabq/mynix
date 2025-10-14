# - Compinit (not actually a plugin but act as one)
autoload -Uz compinit
zstyle ":completion:*" menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # include hidden files

# - ZSH-autosuggestions
#   Nix does not place files here, so it won't find this. Leave it here in
#   case you ever use something else.
if [[ -f /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# - ZSH-syntax-highlighting (this file in not available in Nix)
#   Nix does not place files here, so it won't find this. Leave it here in
#   case you ever use something else.
if [[ -f /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# - ZSH-history-substring-search (replaced with Atuin)
#   Nix does not place files here, so it won't find this. Leave it here in
#   case you ever use something else.
if [[ -f /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh ]]; then
  source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
fi

# - Xoxide
#   https://github.com/ajeetdsouza/zoxide?tab=readme-ov-file#installation
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# - Atuin
#   https://docs.atuin.sh/guide/installation/#installing-the-shell-plugin
if command -v atuin &> /dev/null; then
  eval "$(atuin init zsh)"
fi

# - Starship
#   https://starship.rs/guide/#%F0%9F%9A%80-installation
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# - Mise
#   https://mise.jdx.dev/installing-mise.html#shells
# if command -v mise &> /dev/null; then
#   eval "$(mise activate bash)"
# fi
