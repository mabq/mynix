# Zsh looks for the following configuration files (in order) in the user's
# home directory (defined in `/etc/passwd` for each user) or in `/etc/zsh/`
# for all users.
#
#   - .zshenv   - Should only contain user’s environment variables.
#   - .zprofile - Can be used to execute commands just after logging in.
#   - .zshrc    - For the shell configuration and for executing commands.
#   - .zlogin   - Same purpose than .zprofile, but read just after .zshrc.
#   - .zlogout  - Can be used to execute commands when a shell exit.
#
# Every time we open a terminal, zsh will find this file in the home directory,
# the `$ZDOTDIR` (https://wiki.archlinux.org/title/XDG_Base_Directory) variable
# shows zsh where to look for config files.
#
# For a graphical representation, see:
#   https://blog.flowblok.id.au/2013-02/shell-startup-scripts.html#implementation

# No need to export since this variable is only needed to start zsh.

ZDOTDIR="$HOME/.config/zsh"
