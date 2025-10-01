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
    #    Nix forces me to enable these in a NixOS module.
    #    See '/users/<user>/nixos.nix'.
    # pkgs.zsh-autosuggestions
    # pkgs.zsh-syntax-highlighting
    # pkgs.zsh-history-substring-search  # -- Replaced with Atuin.

    # -- Tools required by aliases.
    pkgs.zoxide
    pkgs.eza
    pkgs.fzf
    pkgs.bat
    pkgs.caligula
    # pkgs.yazi  # -- Installed in its own module to latest version.
    # pkgs.neovim  # -- Installed in its own module to latest version.
    # pkgs.tmux  # -- Installed in its own module.

    # -- This is used as the default history.
    #    Important: In order to sync history in the server you need to
    #    manually execute `atuin login -u <USERNAME>`.
    #    For more information see: https://docs.atuin.sh/guide/sync/#login.
    #    Credentials in password manager.
    pkgs.atuin

    # -- For disk formatting (ext4, exfat) functions.
    pkgs.parted
    pkgs.exfat

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
