{
  config,
  pkgs,
  repo,
  ...
}: let
  outOfStore = config.lib.file.mkOutOfStoreSymlink;
  thisModule = "${repo}/modules/tmux";
in {
  home.packages = [
    pkgs.tmux
    pkgs.fd # required by tmux-sessionizer
    pkgs.fzf # required by tmux-sessionizer
  ];

  # Link the whole directory out-of-store so that no rebuild is required to apply changes (must be an absolute path)
  home.file.".config/tmux".source = outOfStore "${thisModule}/config";

  # Link each binary
  home.file.".local/bin/tmux-sessionizer".source = outOfStore "${thisModule}/bin/tmux-sessionizer";
}
