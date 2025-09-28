# -- Atuin:
#    In order to sync your history to the server you need to manually run
#      `atuin login -u <USERNAME>`.
#    For more information see https://docs.atuin.sh/guide/sync/#login.
#    Remember to store your Atuin password and key in your password manager!
{
  config,
  pkgs,
  repo,
  ...
}: let
  _outOfStore = config.lib.file.mkOutOfStoreSymlink;
  _config = "${repo}/modules/zsh/config";
in {
  imports = [
    ../starship
  ];

  home.packages = [
    pkgs.zsh

    # -- Addons (initialized in addons file):
    pkgs.zsh-autosuggestions
    pkgs.zsh-syntax-highlighting
    # pkgs.zsh-history-substring-search # -- Replaced with Atuin
    pkgs.atuin # -- shared history (see note above)
    pkgs.zoxide # -- replaces `cd`
    pkgs.eza # -- replaces `ls`

    # -- Used by aliases/functions:
    pkgs.parted # for disk formatting (ext4) function
    pkgs.exfat # for disk formatting (exfat) function
    pkgs.caligula # for burning ISO images into external usb drives
    pkgs.ffmpeg # for transcoding video functions
    pkgs.imagemagick # for transcoding image functions
  ];

  # Link `.zshenv` directly under home
  home.file.".zshenv".source = _outOfStore "${_config}/.zshenv";
  # Link the whole `source` directory out-of-store so that no rebuild is
  # required to apply changes (must be an absolute path).
  # (.zcompdump is added to this directory at runtime but is ignored by git)
  home.file.".config/zsh".source = _outOfStore "${_config}/source";
}
