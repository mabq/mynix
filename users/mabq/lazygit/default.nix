{
  pkgs,
  pkgsUnstable,
  outlink,
  userPath,
  ...
}: let
  m = "${userPath}/lazygit";
in {
  # - Install packages
  home.packages = [
    pkgsUnstable.lazygit

    # - required by config file options
    pkgs.delta
  ];

  # - Link lazygit config file (out of store)
  #   Includes delta options
  home.file.".config/lazygit/config.yml".source = outlink "${m}/config/config.yml";
}
