{
  flake.nixosModules.niri =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user host niriConfig;
      dir = "/home/${user}/.local/share/mynix/modules/programs/niri";
    in
    {

      options = {
        mynix.niriConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Selected btop configuration";
        };
      };

      config = {
        programs.niri.enable = true;

        environment.systemPackages = import ./configs/${niriConfig}/_packages.nix pkgs;

        hjem.users.${user}.files = {
          ".config/niri".source = "${dir}/configs/${niriConfig}"; # out of store

          # Per-host outputs
          #  Do not put the file in `~/.config/niri`, otherwise it will always be imported
          ".config/mynix/niri/outputs-macbook.kdl".text = lib.mkIf (host == "macbook") ''
            output "LVDS-1" {
                // Disable macbook phantom display
                off
            }
          '';
        };
      };

    };
}
