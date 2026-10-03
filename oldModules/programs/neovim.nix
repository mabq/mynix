{
  self,
  config,
  lib,
  pkgs,
  inputs,
  user,
  repoConfigDir,
  repoConfigDirAbs,
  ...
}:
let
  cfg = config.mynix.programs.neovim;

  # Avoid breaking if the module is moved to another directory
  packages = self + repoConfigDir + "/nvim/${cfg.configName}/packages.nix";
in
{
  config = lib.mkIf cfg.enable {
    # Map the legacy `<nixpkgs>` lookup directly to the exact Nixpkgs path pinned
    # in the Flake's `flake.lock` file. Watch https://youtu.be/M_zMoHlbZBY?t=196
    nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

    # Make nvim the default text editor.
    # Read session variables notes in the default module for more information
    # about this option..
    environment.sessionVariables = {
      EDITOR = "nvim";
      SUDO_EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home-manager.users.${user} =
      { config, ... }:
      let
        mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
      in
      {
        home = {
          packages = import packages { inherit pkgs; };

          file = {
            ".config/nvim" = {
              source = mkOutOfStoreSymlink "${repoConfigDirAbs}/nvim/${cfg.configName}";
              force = true;
            };
          };
        };
      };
  };
}
