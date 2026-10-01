{
  config,
  lib,
  pkgs,
  user,
  repoConfigDirAbs,
  repoThemeDirAbs,
  ...
}:
let
  cfg = config.mynix.programs.foot;
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
            foot # Fast, lightweight and minimalistic Wayland terminal emulator
          ];

          file = {
            ".config/foot/foot.ini" = {
              source = mkOutOfStoreSymlink "${repoConfigDirAbs}/foot/${cfg.configName}.ini";
              force = true;
            };
            ".config/foot/theme.ini" = {
              # The foot config files does not allow global variables or relative
              # paths, so we cannot point to out local theme dir. We must create
              # this extra symlink to avoid breaking the path if we change the
              # themes dir.
              source = mkOutOfStoreSymlink "${repoThemeDirAbs}/foot.ini";
              force = true;
            };
          };
        };
      };
  };
}
