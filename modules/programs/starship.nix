{
  config,
  lib,
  pkgs,
  user,
  repoConfigDirAbs,
  ...
}:
let
  cfg = config.mynix.programs.starship;
in
{
  config = lib.mkIf cfg.enable {
    home-manager.users.${user} =
      { config, ... }:
      let
        mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
      in
      {
        home = {
          packages = with pkgs; [
            starship # Customizable prompt for any shell
          ];

          file = {
            ".config/starship.toml" = {
              source = mkOutOfStoreSymlink "${repoConfigDirAbs}/starship/${cfg.configName}.toml";
              force = true;
            };
          };
        };
      };
  };
}

# Important!
#  Starship must be initialized by a shell config file.
