# -- In the user's nixos module we define the user's default shell.
{
  pkgs,
  userPath,
  outlink,
  ...
}: let
  m = "${userPath}/zsh";
in {
  home.packages = [
    pkgs.zsh

    # - Nix forces me to enable these in a NixOS module.
    #   See '/users/<user>/nixos.nix'.
    # pkgs.zsh-autosuggestions
    # pkgs.zsh-syntax-highlighting
    # pkgs.zsh-history-substring-search

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

    # - Atuin
    #   In order to sync history in the server you need to manually execute
    #   `atuin login -u <USERNAME>`.
    #   For more information see: https://docs.atuin.sh/guide/sync/#login.
    #   Credentials in password manager.
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

  # - Config files
  #   Just link the .zshenv file, it point to the config files in the local
  #   repository. No need to symlink those.
  home.file.".zshenv".source = outlink "${m}/config/.zshenv";
}
