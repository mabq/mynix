{
  flake.nixosModules.keyd =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) keydConfig;
    in
    {

      options = {
        mynix.keydConfig = lib.mkOption {
          type = lib.types.str;
          default = "default";
          description = "Selected keyd configuration";
        };
      };

      config = {
        # The keyd systemd service runs as root. It captures your input events,
        # remaps them, and emits them to the system at a low level.
        services.keyd.enable = true;

        environment = {
          systemPackages = [
            # Required to debug keycodes with `sudo keyd monitor`
            pkgs.keyd # Key remapping daemon for Linux
          ];

          # Keyd config files
          etc."keyd".source = ./configs/${keydConfig};
        };
      };

    };
}
