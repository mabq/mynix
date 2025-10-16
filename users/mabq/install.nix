# - Install packages
#
#   Most packages should be installed using per-project flakes sourced with
#   direnv and nix-shell.
#
#   The nix packages page shows the commands provided by each package.
{
  pkgs,
  pkgsUnstable,
  ...
}: {
  home.packages = [
    # - Better core utils
    pkgs.bat # - Cat clone with syntax highlighting and Git integration
    pkgs.eza # - Modern, maintained replacement for ls
    pkgs.fd # - Simple, fast and user-friendly alternative to find
    pkgs.ripgrep # - Utility that combines the usability of The Silver Searcher with the raw speed of grep
    pkgs.zoxide # - Fast cd command that learns your habits

    # - Improve shell environment
    pkgs.atuin # - Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines
    pkgs.fzf # - Command-line fuzzy finder written in Go
    pkgs.just # - Handy way to save and run project-specific commands
    pkgs.starship # - Minimal, blazing fast, and extremely customizable prompt for any shell
    pkgs.tmux # - Terminal multiplexer
    # pkgs.openssh # - Implementation of the SSH protocol

    # -- Git
    pkgs.git # - Distributed version control system
    pkgsUnstable.lazygit # - Simple terminal UI for git commands
    pkgs.delta # - Syntax-highlighting pager for git

    # - Encryption
    pkgs.age # - Modern encryption tool with small explicit keys

    # - System info
    pkgs.btop # - Monitor of resources
    pkgs.fastfetch # - Actively maintained, feature-rich and performance oriented, neofetch like system information tool
    pkgs.inxi # - Full featured CLI system information tool
    pkgs.pciutils # - (lspci) Collection of programs for inspecting and manipulating configuration of PCI devices
    pkgs.usbutils # - Tools for working with USB devices, such as lsusb

    # - Help utils
    pkgs.man # - Implementation of the standard Unix documentation system accessed using the man command
    pkgs.tldr # - Simplified and community-driven man pages

    # - Network
    pkgs.aria2 # - Lightweight, multi-protocol, multi-source, command-line download utility
    pkgs.curl # - Command line tool for transferring files with URL syntax
    pkgs.inetutils # - Collection of common network programs
    pkgs.wget # - Tool for retrieving files using HTTP, HTTPS, and FTP
    pkgs.speedtest-go # - CLI and Go API to Test Internet Speed using speedtest.net
    pkgs.impala # - TUI for managing wifi (for iwd)

    # - Bluetooth
    pkgs.bluetui # - TUI for managing bluetooth on Linux

    # - Disks
    pkgs.caligula # - User-friendly, lightweight TUI for disk imaging
    pkgs.exfat # - Free exFAT file system implementation
    pkgs.ncdu # - Disk usage analyzer with an ncurses interface
    pkgs.parted # - Create, destroy, resize, check, and copy partitions

    # - Neovim
    pkgsUnstable.neovim # - Vim text editor fork focused on extensibility and agility
    #   C
    pkgs.gnumake # - (Telescope) Tool to control the generation of non-source files from sources
    pkgs.clang # - (Treesitter) C language family frontend for LLVM
    #   Lua
    pkgs.lua-language-server # - Language server that offers Lua language support
    pkgs.stylua # - Opinionated Lua code formatter
    #   Bash
    pkgs.bash-language-server # - Language server for Bash
    pkgs.shfmt # - Shell parser and formatter
    #   Nix
    pkgs.nixd # - Feature-rich Nix language server interoperating with C++ nix
    pkgs.alejandra # - Uncompromising Nix Code Formatter
    #   JavaScript
    pkgs.biome # - Toolchain of the web

    # - Yazi
    pkgsUnstable.yazi # - Blazing fast terminal file manager written in Rust, based on async I/O
    pkgs.file # (file type detection) Program that shows the type of files
    pkgs.ffmpeg # - (video thumbnails) Complete, cross-platform solution to record, convert and stream audio and video
    pkgs.imagemagick # - (Font, HEIC and JPEG preview) Software suite to create, edit, compose, or convert bitmap images
    pkgs.poppler # - (PDF preview) PDF rendering library
    pkgs.resvg # - (SVG preview) SVG rendering library
    pkgs.p7zip # - (archive extraction) New p7zip fork with additional codecs and improvements
    pkgs.jq # - (JSON preview) Lightweight and flexible command-line JSON processor
    pkgs.wl-clipboard # - (Linux clipboard support) Command-line copy/paste utilities for Wayland
    pkgs.dragon-drop # - Simple drag-and-drop source/sink for X or Wayland
    pkgs.hyprpaper # - (set wallpaper) Blazing fast wayland wallpaper utility
  ];
}
