# -- Better `cd`
alias cd="zd"
zd() {
  if [ $# -eq 0 ]; then
    builtin cd ~ && return
  elif [ -d "$1" ]; then
    builtin cd "$1"
  else
    z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}


# -- Better `ls`
alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'


# -- Better `dd`
alias burniso="caligula burn" # pass the iso path as argument


# -- Search files with preview
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"


# -- Change directory when exiting Yazi
#    https://yazi-rs.github.io/docs/quick-start#shell-wrapper
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}


# -- Shortcut for neovim
n() {
  if [ "$#" -eq 0 ]; then
    nvim .;
  else
    nvim "$@";
  fi;
}


# -- Shortcut for xdg-open
open() {
  xdg-open "$@" >/dev/null 2>&1 &
}


# -- Filesystem
alias mkdir='mkdir -p'
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


# -- Systemctl shortcuts
alias reboot='systemctl reboot'
alias shutdown='systemctl poweroff'
alias suspend='systemctl suspend' # hypridle will automatically run hyprlock on suspend


# -- Curl helpers
alias my-ip-json='curl https://ipapi.co/json/'
alias my-ip='curl icanhazip.com'
alias weather='curl wttr.in'


# -- Convinience
alias path='echo $PATH | tr ":" "\n"'
alias sha256='shasum -a 256'
# alias fontname="fc-query -f '%{family[0]}\n'" # pass the font path as argument
# alias fonts='fc-list : family | sort | uniq | sk --layout=reverse'
# alias fonts='ghostty +list-fonts | fzf'
# alias hw-cpu='bat /proc/cpuinfo'
# alias hw-drivers='lspci -k'
# alias hw-gpu='lspci | grep -E "VGA|3D"'
# alias keycodes="xev | awk -F '[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf \"%-3s %s\n\", \$5, \$8 }'"
# alias mdserve='mdbook serve --open'
# alias mousecodes='xev -event button | grep button'
# alias nc='new-component' # https://www.joshwcomeau.com/react/file-structure/#more-boilerplate-11
# alias psbyuser='ps --no-headers -Leo user | sort | uniq --count'
# alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -'


# -- Mount disks
# alias mount-series='sudo mount /dev/disk/by-uuid/EBC6-97B8 /mnt/series'
# alias umount-series='sudo umount /mnt/series && sleep 3 && sudo hdparm -y /dev/disk/by-uuid/EBC6-97B8'
# alias mount-alejandro='sudo mount /dev/disk/by-uuid/04D0-1DBF /mnt/alejandro'
# alias umount-alejandro='sudo umount /mnt/alejandro && sleep 3 && sudo hdparm -y /dev/disk/by-uuid/04D0-1DBF'
# alias mount-courses='sudo mount /dev/disk/by-uuid/7443-E3E7 /mnt/courses'
# alias umount-courses='sudo umount /mnt/courses && sleep 3 && sudo hdparm -y /dev/disk/by-uuid/7443-E3E7'


# -- Format disks
#    TODO: Check these functions when Nautilus is installed.
#    These functions assumes external disks are auto-mounted to `/run/media/`
#    which is where tools like udisks2 auto-mount disks.
format-ext4() {
  if [ $# -ne 2 ]; then
    echo "Usage: format-ext4 <device> <label>"
    echo "Example: format-ext4 /dev/sda 'Courses'"
    echo -e "\nAvailable drives:"
    lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
  else
    echo "WARNING: This will completely erase all data on $1 and label it '$2'."
    read -rp "Are you sure you want to continue? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      sudo wipefs -a "$1"
      sudo dd if=/dev/zero of="$1" bs=1M count=100 status=progress
      sudo parted -s "$1" mklabel gpt
      sudo parted -s "$1" mkpart primary ext4 1MiB 100%
      sudo mkfs.ext4 -L "$2" "$([[ $1 == *"nvme"* ]] && echo "${1}p1" || echo "${1}1")"
      sudo chmod -R 777 "/run/media/$USER/$2"
      echo "Drive $1 formatted and labeled '$2'."
    fi
  fi
}

format-exfat() {
  if [ $# -ne 2 ]; then
    echo "Usage: format-exfat <device> <label>"
    echo "Example: format-exfat /dev/sda 'Pocket'"
    echo -e "\nAvailable drives:"
    lsblk -d -o NAME -n | awk '{print "/dev/"$1}'
  else
    echo "WARNING: This will completely erase all data on $1 and label it '$2'."
    read -rp "Are you sure you want to continue? (y/N): " confirm
    if [[ "$confirm" =~ ^[Yy]$ ]]; then
      sudo wipefs -a "$1"
      sudo dd if=/dev/zero of="$1" bs=1M count=100 status=progress
      sudo parted -s "$1" mklabel msdos
      sudo parted -s "$1" mkpart primary exfat 0% 100%
      sudo mkfs.exfat -n "$2" "$([[ $1 == *"nvme"* ]] && echo "${1}p1" || echo "${1}1")"
      sudo chmod -R 777 "/run/media/$USER/$2"
      echo "Drive $1 formatted and labeled '$2'."
    fi
  fi
}


# -- Transcode a video
transcode-video-1080p() {
  ffmpeg -i $1 -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy ${1%.*}-1080p.mp4
}

transcode-video-4K() {
  ffmpeg -i $1 -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k ${1%.*}-optimized.mp4
}


# -- Transcode any image to JPG
img2jpg() {
  magick $1 -quality 95 -strip ${1%.*}.jpg
}

img2jpg-small() {
  magick $1 -resize 1080x\> -quality 95 -strip ${1%.*}.jpg
}

img2png() {
  magick "$1" -strip -define png:compression-filter=5 \
    -define png:compression-level=9 \
    -define png:compression-strategy=1 \
    -define png:exclude-chunk=all \
    "${1%.*}.png"
}


# -- Compress/decompress
#    This can be done with Yazi now
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"
# extract () {
#   if [ -f $1 ] ; then
#     case $1 in
#     *.tar.bz2)   tar xjvf $1    ;;
#     *.tar.gz)    tar xzvf $1    ;;
#     *.tar.xz)    tar xvf $1    ;;
#     *.bz2)       bzip2 -d $1    ;;
#     *.rar)       unrar $1    ;;
#     *.gz)        gunzip $1    ;;
#     *.tar)       tar xf $1    ;;
#     *.tbz2)      tar xjf $1    ;;
#     *.tgz)       tar xzf $1    ;;
#     *.zip)       unzip $1     ;;
#     *.Z)         uncompress $1    ;;
#     *.7z)        7z x $1    ;;
#     # *.ace)       unace x $1    ;;
#     *)           echo "'$1' cannot be extracted via extract()"   ;;
#     esac
#   else
#       echo "'$1' is not a valid file"
#   fi
# }


# -- Avoid execution
alias fsck='echo "Never use file system repair software such as fsck directly on an encrypted volume, or it will destroy any means to recover the key used to decrypt your files. Such tools must be used on the decrypted (opened) device instead"'
