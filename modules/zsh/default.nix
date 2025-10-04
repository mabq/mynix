{
  config,
  pkgs,
  repo,
  ...
}: let
  _outOfStore = config.lib.file.mkOutOfStoreSymlink;
  _home = "${repo}/modules/zsh/home";
  _config = "${repo}/modules/zsh/config";
in {
  home.packages = [
    pkgs.zsh

    # -- Nix forces me to enable these in a NixOS module. See '/users/<user>/nixos.nix'.
    # pkgs.zsh-autosuggestions
    # pkgs.zsh-syntax-highlighting
    # pkgs.zsh-history-substring-search

    # -- Shell core utils.
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

    # -- Shell history.
    #    Important: In order to sync history in the server you need to
    #    manually execute `atuin login -u <USERNAME>`.
    #    For more information see: https://docs.atuin.sh/guide/sync/#login.
    #    Credentials in password manager.
    pkgs.atuin

    # -- Disk formatting (ext4, exfat) functions.
    pkgs.parted
    pkgs.exfat

    # -- Disk usage
    pkgs.ncdu

    # -- Video/image transcoding functions.
    pkgs.ffmpeg
    pkgs.imagemagick

    # -- System info
    pkgs.fastfetch

    # -- Easier, more secure `dd`
    pkgs.caligula

    # -- Torrents
    pkgs.aria2
  ];

  # -- Config files
  #    Unlike the rest of config files`.zshenv` must go directly under home.
  home.file.".zshenv".source = _outOfStore "${_home}/.zshenv";
  #    Link the whole config directory
  #    Zsh will add the `.zcompdump` file to this directory, we ignore with git.
  home.file.".config/zsh".source = _outOfStore "${_config}";
}
