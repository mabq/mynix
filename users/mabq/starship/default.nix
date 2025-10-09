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

  # -- Link config file out of nix store.
  home.file.".config/starship.toml".source = _outOfStore "${_config}/starship.toml";

  # -- Note:
  #    Starship is initialized by the zsh `init` config file.
}
