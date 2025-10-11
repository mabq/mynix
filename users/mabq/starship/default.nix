# - Starship is initialized by the zsh `init` config file.
{
  pkgs,
  userPath,
  outlink,
  ...
}: let
  m = "${userPath}/starship";
in {
  home.packages = [
    pkgs.starship
  ];

  # -- Link config file out of nix store.
  home.file.".config/starship.toml".source = outlink "${m}/config/starship.toml";
}
