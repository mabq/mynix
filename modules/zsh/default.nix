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

    # -- Zsh plugins:
    #    Nix forces me to enable these in a NixOS module, see '/users/<user>/nixos.nix'.
    # pkgs.zsh-autosuggestions
    # pkgs.zsh-syntax-highlighting

    # -- Replaced with Atuin
    # pkgs.zsh-history-substring-search

    # -- This is used as the default `cd`. See aliases.
    pkgs.zoxide

    # -- This is used as the default `ls`. See aliases.
    pkgs.eza

    # -- This is used as the default history.
    #    Important: In order to sync history in the server you need to
    #    manually execute `atuin login -u <USERNAME>`.
    #    For more information see: https://docs.atuin.sh/guide/sync/#login.
    #    Credentials in password manager.
    pkgs.atuin

    # -- For disk formatting (ext4, exfat) functions.
    pkgs.parted
    pkgs.exfat

    # -- For ISO burning.
    pkgs.caligula

    # -- For video/image transcoding functions.
    pkgs.ffmpeg
    pkgs.imagemagick
  ];

  # Link `.zshenv` directly under home.
  home.file.".zshenv".source = _outOfStore "${_home}/.zshenv";

  # Link the whole `source` directory out-of-store so that no rebuild is
  # required to apply changes (must be an absolute path).
  # (.zcompdump is added to this directory at runtime but is ignored by git).
  home.file.".config/zsh".source = _outOfStore "${_config}";
}
