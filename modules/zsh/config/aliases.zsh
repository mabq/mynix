# -- Filesystem
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias mkdir='mkdir -p'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
# alias chgrp='chgrp --preserve-root'
# alias chmod='chmod -c --preserve-root'
# alias chown='chown -c --preserve-root'
# alias ln='ln -iv'
# alias cp='cp -iv'
# alias mv='mv -iv'
# alias rm='rm -iv --preserve-root'

# -- Directories
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# -- Neovim
function n() {
  if [ "$#" -eq 0 ]; then
    nvim .;
  else
    nvim "$@";
  fi;
}

# -- Zoxide
alias cd="zd"
function zd() {
  if [ $# -eq 0 ]; then
    builtin cd ~ && return
  elif [ -d "$1" ]; then
    builtin cd "$1"
  else
    z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}

# -- Yazi
#    Change cwd on exiting. See https://yazi-rs.github.io/docs/quick-start#shell-wrapper
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# -- Git
alias ga="git add";
alias gc="git commit";
alias gco="git checkout";
alias gcp="git cherry-pick";
alias gd="git diff";
alias gl="git prettylog";
alias gp="git push";
alias gs="git status";
alias gt="git tag";

# -- Utils (see functions for more)
alias burniso="caligula burn" # pass the iso path as argument
alias fsck='echo "Never use file system repair software such as fsck directly on an encrypted volume, or it will destroy any means to recover the key used to decrypt your files. Such tools must be used on the decrypted (opened) device instead"'
alias my-ip-json='curl https://ipapi.co/json/'
alias my-ip='curl icanhazip.com'
alias path='echo $PATH | tr ":" "\n"'
alias reboot='systemctl reboot'
alias sha256='shasum -a 256'
alias shutdown='systemctl poweroff'
alias suspend='systemctl suspend' # hypridle will automatically run hyprlock on suspend
alias ta='tmux attach'
alias trash='trash-put'
alias wifi='nmtui'


# -- Disabled
# alias fontname="fc-query -f '%{family[0]}\n'" # pass the font path as argument
# alias fonts='fc-list : family | sort | uniq | sk --layout=reverse'
# alias fonts='ghostty +list-fonts | fzf'
# alias h='history -i 1'
# alias hw-cpu='bat /proc/cpuinfo'
# alias hw-drivers='lspci -k'
# alias hw-gpu='lspci | grep -E "VGA|3D"'
# alias keycodes="xev | awk -F '[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf \"%-3s %s\n\", \$5, \$8 }'"
# alias logout='loginctl terminate-user $USER'
# alias mdserve='mdbook serve --open'
# alias mousecodes='xev -event button | grep button'
# alias nc='new-component' # https://www.joshwcomeau.com/react/file-structure/#more-boilerplate-11
# alias plex='flatpak run tv.plex.PlexDesktop'
# alias psbyuser='ps --no-headers -Leo user | sort | uniq --count'
# alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'
# alias weather='curl wttr.in'

# -- External disks (the UUID of a disk will change when formatted)
# alias mount-series='sudo mount /dev/disk/by-uuid/EBC6-97B8 /mnt/series'
# alias umount-series='sudo umount /mnt/series && sleep 3 && sudo hdparm -y /dev/disk/by-uuid/EBC6-97B8'
# alias mount-alejandro='sudo mount /dev/disk/by-uuid/04D0-1DBF /mnt/alejandro'
# alias umount-alejandro='sudo umount /mnt/alejandro && sleep 3 && sudo hdparm -y /dev/disk/by-uuid/04D0-1DBF'
# alias mount-courses='sudo mount /dev/disk/by-uuid/7443-E3E7 /mnt/courses'
# alias umount-courses='sudo umount /mnt/courses && sleep 3 && sudo hdparm -y /dev/disk/by-uuid/7443-E3E7'

