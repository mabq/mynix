{
  lib,
  config,
  pkgs,
  user,
  repoConfigDirAbs,
  ...
}:
let
  cfg = config.mynix.programs.git;
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
            git # Distributed version control system
            gh # CLI GitHub tool (authenticate from the terminal)
            lazygit # Simple terminal UI for git commands
            delta # Syntax-highlighting pager for git
          ];

          file = {
            ".config/git/config" = {
              source = mkOutOfStoreSymlink "${repoConfigDirAbs}/git/${cfg.configName}";
              force = true;
            };
            ".config/lazygit/config.yml" = {
              source = mkOutOfStoreSymlink "${repoConfigDirAbs}/lazygit/default.yml";
              force = true;
            };
          };
        };
      };
  };
}
