{
  pkgs,
  outlink,
  userPath,
  ...
}: let
  m = "${userPath}/git";
in {
  # - Install packages
  home.packages = [
    pkgs.git

    # - required by config file options
    pkgs.delta
  ];

  # - Link git config file (out of store)
  #   The git config file includes delta options
  home.file.".config/git/config".source = outlink "${m}/config/config";
}
