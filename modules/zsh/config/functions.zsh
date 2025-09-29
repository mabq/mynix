# -- Alias for xdg-open
function open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

# -- Compression
compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"

# -- Format an entire drive for a single partition using ext4
#    TODO: Check this functions when Nautilus is installed.
#    This function assumes external disks are auto-mounted to `/run/media/`
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

# -- Format a USB drive to use it in Linux, Mac and Windows.
#    TODO: Check this functions when Nautilus is installed.
#    This function assumes external disks are auto-mounted to `/run/media/`
#    which is where tools like udisks2 auto-mount disks.
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

# -- Transcode a video to a good-balance 1080p that's great for sharing online
transcode-video-1080p() {
  ffmpeg -i $1 -vf scale=1920:1080 -c:v libx264 -preset fast -crf 23 -c:a copy ${1%.*}-1080p.mp4
}
# -- Transcode a video to a good-balance 4K that's great for sharing online
transcode-video-4K() {
  ffmpeg -i $1 -c:v libx265 -preset slow -crf 24 -c:a aac -b:a 192k ${1%.*}-optimized.mp4
}

# -- Transcode any image to JPG image that's great for shrinking wallpapers
img2jpg() {
  magick $1 -quality 95 -strip ${1%.*}.jpg
}

# -- Transcode any image to JPG image that's great for sharing online without being too big
img2jpg-small() {
  magick $1 -resize 1080x\> -quality 95 -strip ${1%.*}.jpg
}

# -- Transcode any image to compressed-but-lossless PNG
img2png() {
  magick "$1" -strip -define png:compression-filter=5 \
    -define png:compression-level=9 \
    -define png:compression-strategy=1 \
    -define png:exclude-chunk=all \
    "${1%.*}.png"
}

# -- (Decompress can now be handled by Yazi with the p7zip package).
# function extract () {
#     # Easily extract archives
#     if [ -f $1 ] ; then
#         case $1 in
#         *.tar.bz2)   tar xjvf $1    ;;
#         *.tar.gz)    tar xzvf $1    ;;
#         *.tar.xz)    tar xvf $1    ;;
#         *.bz2)       bzip2 -d $1    ;;
#         *.rar)       unrar $1    ;;
#         *.gz)        gunzip $1    ;;
#         *.tar)       tar xf $1    ;;
#         *.tbz2)      tar xjf $1    ;;
#         *.tgz)       tar xzf $1    ;;
#         *.zip)       unzip $1     ;;
#         *.Z)         uncompress $1    ;;
#         *.7z)        7z x $1    ;;
#         # *.ace)       unace x $1    ;;
#         *)           echo "'$1' cannot be extracted via extract()"   ;;
#         esac
#     else
#         echo "'$1' is not a valid file"
#     fi
# }

