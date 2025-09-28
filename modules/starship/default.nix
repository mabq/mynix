{
  config,
  pkgs,
  repo,
  ...
}: let
  _outOfStore = config.lib.file.mkOutOfStoreSymlink;
  _config = "${repo}/modules/starship/config";
in {
  home.packages = [
    pkgs.starship
  ];

  # Link the config file out-of-store so that no rebuild is required to
  # apply changes (must be an absolute path).
  home.file.".config/starship.toml".source = _outOfStore "${_config}/starship.toml";
}
