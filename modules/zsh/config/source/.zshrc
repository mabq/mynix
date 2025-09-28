# Why `$ZDOTDIR`?
#   We must use an absolute path, `source` takes the path relative to the
#   current working directory, not relative to the config file itself.
source "$ZDOTDIR/options.zsh"
source "$ZDOTDIR/bindkey.zsh"
source "$ZDOTDIR/functions.zsh"  # must go before aliases
source "$ZDOTDIR/envs.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/addons.zsh"

# source "$ZDOTDIR/source-disks/aliases.zsh"
