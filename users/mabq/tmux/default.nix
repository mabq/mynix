# - In the zsh module we bind a key to launch tmux-sessionizer.
{
  pkgs,
  userPath,
  outlink,
  ...
}: let
  m = "${userPath}/tmux";
in {
  home.packages = [
    pkgs.tmux

    # - Required by tmux-sessionizer
    pkgs.fd
    pkgs.fzf
  ];

  # - Link the whole config directory (out of store)
  home.file.".config/tmux".source = outlink "${m}/config";

  # - Link each binary (out of store)
  home.file.".local/bin/tmux-sessionizer".source = outlink "${m}/bin/tmux-sessionizer";
}
