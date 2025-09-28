# Changes not seen here:
#   - In zsh we bind a key to launch tmux-sessionizer.
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
    pkgs.fd # Required by tmux-sessionizer
    pkgs.fzf # Required by tmux-sessionizer
  ];

  # Link the whole directory out-of-store so that no rebuild is required to apply changes (must be an absolute path)
  home.file.".config/tmux".source = _outOfStore "${_config}";

  # Link each binary
  home.file.".local/bin/tmux-sessionizer".source = _outOfStore "${_bin}/tmux-sessionizer";
}
