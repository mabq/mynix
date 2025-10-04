# -- Add to path
export PATH="$HOME/.local/bin:$PATH" # TODO: Omarchy sets this in uwsm

# -- zsh istory options
mkdir -p ~/.cache/zsh
export HISTSIZE=10000
export SAVEHIST="${HISTSIZE}"
export HISTFILE=~/.cache/zsh/history  # be careful not to include this file on any git repo


# -- TODO: XDG Base Directory
#    Only XDG_RUNTIME_DIR is set by default through pam_systemd(8). It is up to the user to explicitly define the other variables according to the specification.
#    https://wiki.archlinux.org/title/XDG_Base_Directory#User_directories
# export XDG_CONFIG_HOME="$HOME/.config"  # $HOME value is taken from `/etc/passwd`
# export XDG_CACHE_HOME="$HOME/.cache"
# export XDG_DATA_HOME="$HOME/.local/share"
# export XDG_STATE_HOME="$HOME/.local/state"
# export XDG_DATA_DIRS=""
# export XDG_CONFIG_DIRS="/etc/xdg"


# -- ssh-agent
#    Environment variable that points to a Unix socket file created by the
#    ssh-agent. That socket is the communication channel between your
#    applications and the running ssh-agent. When you run ssh, it checks this
#    variable to know where to talk to the agent.
# export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"  # -- In Archlinux
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent"  # -- In NixOS


# -- TODO: Env variables for default programs:
#   Omarchy set these with uwsm.
#   These variables define default applications when executing commands from the terminal.
#   Do not set the `TERM` variable!, it is set by each terminal emulator.
export EDITOR="nvim"
export SUDO_EDITOR="$EDITOR"
export VISUAL="nvim"  # when opening a GUI editor (nnn `-e` option will respect this variable)
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export PAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"  # https://wiki.archlinux.org/title/Color_output_in_console#Using_less
export LANG="en_US.UTF-8";
export LC_CTYPE="en_US.UTF-8";
export LC_ALL="en_US.UTF-8";
# export BROWSER="brave"  # when opening links
# export GPG_TTY="${TTY:-$(tty)}"


# -- Themes
export BAT_THEME="ansi"
export GTK_THEME="Adwaita:dark"


# fzf tokyonight: https://github.com/folke/tokyonight.nvim/tree/main/extras/fzf
# export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
#   --highlight-line \
#   --info=inline-right \
#   --ansi \
#   --layout=reverse \
#   --border=none
#   --color=bg+:#283457 \
#   --color=bg:#16161e \
#   --color=border:#27a1b9 \
#   --color=fg:#c0caf5 \
#   --color=gutter:#16161e \
#   --color=header:#ff9e64 \
#   --color=hl+:#2ac3de \
#   --color=hl:#2ac3de \
#   --color=info:#545c7e \
#   --color=marker:#ff007c \
#   --color=pointer:#ff007c \
#   --color=prompt:#2ac3de \
#   --color=query:#c0caf5:regular \
#   --color=scrollbar:#27a1b9 \
#   --color=separator:#ff9e64 \
#   --color=spinner:#ff007c \
# "
