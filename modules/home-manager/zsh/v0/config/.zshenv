# README!
#
# Zsh looks for the following configuration files in the user's home directory,
# if none is found it falls back to `/etc/zsh/`.
#
# > Note: Home directories for each user are specified in `/etc/passwd`.
#
#   - .zshenv   - Should only contain user’s environment variables.
#   - .zprofile - Can be used to execute commands just after logging in.
#   - .zshrc    - For the shell configuration and for executing commands.
#   - .zlogin   - Same purpose than .zprofile, but read just after .zshrc.
#   - .zlogout  - Can be used to execute commands when a shell exit.
#
# Every time we open a terminal, zsh will find this file in the home directory,
# the `$ZDOTDIR` variable shows zsh where to look for config files. See:
#   https://wiki.archlinux.org/title/XDG_Base_Directory
#
# For a graphical representation, see:
#   https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html#implementation

# No need to export since this variable is only needed to start zsh.

# In NixOS make zsh point to config files in mynix local repository.
# ZDOTDIR="$HOME/.config/zsh"
