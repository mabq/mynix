# -- Note:
#    In zsh we bind a key to launch tmux-sessionizer.
{
  config,
  pkgs,
  repo,
  ...
}: let
  _outOfStore = config.lib.file.mkOutOfStoreSymlink;
  _config = "${repo}/modules/tmux/config";
  _bin = "${repo}/modules/tmux/bin";
in {
  home.packages = [
    pkgs.tmux

    # -- Dependencies
    pkgs.fd # -- required by tmux-sessionizer
    pkgs.fzf # -- required by tmux-sessionizer
  ];

  # -- Config files
  #    Link the whole directory
  home.file.".config/tmux".source = _outOfStore "${_config}";

  # -- Binaries
  #    Link each binary
  home.file.".local/bin/tmux-sessionizer".source = _outOfStore "${_bin}/tmux-sessionizer";
}
