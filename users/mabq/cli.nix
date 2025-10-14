{
  pkgs,
  pkgsUnstable,
  flakePath,
  configPath,
  binPath,
  outlink,
  theme,
  ...
}: {
  # - Most packages should be installed using per-project flakes sourced with
  #   direnv and nix-shell.
  # - The packages page shows the commands provided by each package.
  home.packages = [
    # - Core utils replacements
    pkgs.bat # - Cat clone with syntax highlighting and Git integration
    pkgs.eza # - Modern, maintained replacement for ls
    pkgs.fd # - Simple, fast and user-friendly alternative to find
    pkgs.ripgrep # - Utility that combines the usability of The Silver Searcher with the raw speed of grep
    pkgs.zoxide # - Fast cd command that learns your habits

    # - Encryption
    pkgs.age # - Modern encryption tool with small explicit keys

    # -- Git
    pkgs.git # - Distributed version control system
    pkgsUnstable.lazygit # - Simple terminal UI for git commands
    pkgs.delta # - Syntax-highlighting pager for git

    # - Extend shell usability
    pkgs.atuin # - Replacement for a shell history which records additional commands context with optional encrypted synchronization between machines
    pkgs.fzf # - Command-line fuzzy finder written in Go
    pkgs.just # - Handy way to save and run project-specific commands
    pkgs.starship # - Minimal, blazing fast, and extremely customizable prompt for any shell
    pkgs.tmux # - Terminal multiplexer

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

    # - Disks
    pkgs.caligula # - User-friendly, lightweight TUI for disk imaging
    pkgs.exfat # - Free exFAT file system implementation
    pkgs.ncdu # - Disk usage analyzer with an ncurses interface
    pkgs.parted # - Create, destroy, resize, check, and copy partitions

    # - Neovim
    pkgsUnstable.neovim # - Vim text editor fork focused on extensibility and agility
    #   (C compilers)
    pkgs.gnumake # - (Telescope) Tool to control the generation of non-source files from sources
    pkgs.clang # - (Treesitter) C language family frontend for LLVM
    #   (LSPs)
    pkgs.lua-language-server # - Language server that offers Lua language support
    pkgs.bash-language-server # - Language server for Bash
    pkgs.nixd # - Feature-rich Nix language server interoperating with C++ nix
    #   (Formatters)
    pkgs.stylua # - Opinionated Lua code formatter
    pkgs.shfmt # - Shell parser and formatter
    pkgs.alejandra # - Uncompromising Nix Code Formatter
    pkgs.biome # - Toolchain of the web

    # - Yazi
    pkgsUnstable.yazi # - Blazing fast terminal file manager written in Rust, based on async I/O
    pkgs.file # (file type detection) Program that shows the type of files
    pkgs.ffmpeg # - (video thumbnails) Complete, cross-platform solution to record, convert and stream audio and video
    pkgs.p7zip # - (archive extraction) New p7zip fork with additional codecs and improvements
    pkgs.jq # - (JSON preview) Lightweight and flexible command-line JSON processor
    pkgs.poppler # - (PDF preview) PDF rendering library
    pkgs.resvg # - (SVG preview) SVG rendering library
    pkgs.imagemagick # - (Font, HEIC and JPEG preview) Software suite to create, edit, compose, or convert bitmap images
    pkgs.wl-clipboard # - (Linux clipboard support) Command-line copy/paste utilities for Wayland
    pkgs.dragon-drop # - Simple drag-and-drop source/sink for X or Wayland
    pkgs.hyprpaper # - (set wallpaper) Blazing fast wayland wallpaper utility
  ];

  # ---------------------------------------------------------------------------
  # Config files
  # ---------------------------------------------------------------------------

  # - Theme
  #
  #   Theme files are placed at the root of the repository because those are
  #   meant to be shared by all users.
  #
  #   All config files point to a fixed directory. Set a theme by changing the
  #   symlink to point to a different theme.
  home.file.".config/mynix/current/theme".source = outlink "${flakePath}/themes/${theme}";

  # - Zsh
  #
  #   The user's default shell (`etc/password`) can only be set with a NixOS
  #   module. Therefore, zsh setup is done in the user's system file.
  #
  #   `.zcompdump*` has been added to `.gitignore` so that git ignores that
  #   file (automatically added by zsh in the config directory).
  #
  #   Symlink the .zshenv file. It instructs zsh to look for config files in
  #   this repository. No need to make it out of store.
  home.file.".zshenv".source = ./config/zsh/.zshenv;

  # - Age
  #
  #    Do NOT link the whole directory!. This is where you place the decrypted
  #    version of the key!
  #
  #    Do NOT change the name of the key file, otherwise also update the script
  #    in this module.
  home.file.".config/age/key.txt.age".source = outlink "${configPath}/age/key.txt.age";

  # - Git/Delta
  #
  #   The git config file includes delta configs.
  home.file.".config/git/config".source = outlink "${configPath}/git/config";

  # - Lazygit
  #
  #   Config file uses delta to show diffs.
  home.file.".config/lazygit/config.yml".source = outlink "${configPath}/lazygit/config.yml";

  # - Atuin
  #
  #   Automatically initialized by zsh (`init.zsh`).
  #
  #   To backup or sync your history with other machines manually run
  #   `atuin login -u <username>`. Credentials in password manager.
  #   For more information see; https://docs.atuin.sh/guide/sync/#login

  # - Tmux
  #
  #   Out of store symlink to config directory.
  home.file.".config/tmux".source = outlink "${configPath}/tmux/";

  # - Neovim
  #
  #   Out of store symlink to config directory.
  home.file.".config/nvim".source = outlink "${configPath}/nvim/";

  # - Yazi
  #
  #   The shell alias `y` allows changing the cwd on exit.
  #
  #   Some tmux configs are required to enable image preview within tmux.
  #
  #   Out of store symlink to config directory.
  home.file.".config/yazi".source = outlink "${configPath}/yazi/";

  # - Starship
  #
  #   Automatically initialized by zsh (`init.zsh`).
  #
  #   Out of store symlink to config file.
  home.file.".config/starship.toml".source = outlink "${configPath}/starship/starship.toml";

  # - SSH
  #
  #   Client side of ssh, server side in configured in the host.
  #
  #   Configure ssh the nix way:
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };
  #
  #   Enable ssh-agent:
  #   It holds your decrypted private keys in memory, so you only need to
  #   enter the passphrase once.
  #   The agent is provided as a systemd USER service.
  #   The zsh module exports the `SSH_AUTH_SOCK` env variable so that
  #   applications know how to talk to the agent.
  services.ssh-agent.enable = true;
  #
  #   Config files:
  #   Do NOT link the entire directory!, you don't want any new keys to be
  #   included in the public repo.
  #   Do NOT change the name of the ssh key, otherwise also update the script
  #   in the age module.
  home.file.".ssh/id_ed25519.age".source = outlink "${configPath}/ssh/id_ed25519.age";
  home.file.".ssh/id_ed25519.pub".source = outlink "${configPath}/ssh/id_ed25519.pub";

  # ---------------------------------------------------------------------------
  # Binaries
  # ---------------------------------------------------------------------------

  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
  };
}
