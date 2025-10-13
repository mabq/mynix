# - Important!
#   Changing the default shell (the one set in `/etc/passwd`) requires root
#   privileges, because it’s a system-level user property. In NixOS, only a
#   NixOS module (not Home-manager) can do that.
#   So, all nix configurations for the default shell are in the user's nixos
#   config file. Here, we symlink the shell config files and install packages
#   required by aliases and functions.
#
# - gitignore
#   Add an entry to `.gitignore` with `.zcompdump*` to ignore the file that
#   zsh automatically adds to the config file directory.
{
  pkgs,
  userPath,
  outlink,
  ...
}: let
  m = "${userPath}/zsh";
in {
  home.packages = [
    # - The default shell package is owned by the user's NixOS module.
    # pkgs.zsh

    # - Shell core utils.
    pkgs.bat
    pkgs.curl
    pkgs.eza
    pkgs.fd
    pkgs.fzf
    pkgs.ripgrep
    pkgs.tldr
    pkgs.wget
    pkgs.zoxide
    pkgs.man

    # - Atuin is an awesome history plugin.
    #   You can sync history across multiple machines by syncing your history
    #   to a server. If you wish to do that simply manually run:
    #     `atuin login -u <USERNAME>`.
    #   For more information see:
    #     https://docs.atuin.sh/guide/sync/#login.
    #   Atuin credentials are stored in the password manager.
    pkgs.atuin

    # - Disk formatting (ext4, exfat) functions.
    pkgs.parted
    pkgs.exfat

    # - Disk usage
    pkgs.ncdu

    # - Video/image transcoding functions.
    pkgs.ffmpeg
    pkgs.imagemagick

    # - System info
    pkgs.fastfetch

    # - Easier, more secure `dd`
    pkgs.caligula

    # - Torrents
    pkgs.aria2
  ];

  # - Plugins
  #   Since the NixOS module owns the zsh configuration, these must also be
  #   placed there.
  # programs.zsh.syntaxHighlighting.enable = true;
  # programs.zsh.autosuggestion.enable = true;

  # - Config files
  #   Just link the .zshenv file, it point to the config files in the local
  #   repository. No need to symlink those.
  home.file.".zshenv".source = outlink "${m}/config/.zshenv";
}
