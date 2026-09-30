{
  lib,
  config,
  pkgs,
  user,
  repoConfigDirAbs,
  localThemeDirAbs,
  ...
}:
let
  cfg = config.mynix.programs.btop;
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
            btop # Monitor of resources
          ];

          file = {
            ".config/btop/btop.conf" = {
              source = mkOutOfStoreSymlink "${repoConfigDirAbs}/btop/${cfg.configName}.conf";
              force = true;
            };
            ".config/btop/themes/current.theme" = {
              source = mkOutOfStoreSymlink "${localThemeDirAbs}/btop.theme";
              force = true;
            };
          };
        };
      };
  };
}

/*
  Related configurations:
    The defaults module creates local theme dir symlink.
*/
