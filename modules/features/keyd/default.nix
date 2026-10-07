{ config, lib, ... }:
{
  options = {
    mynix.keyd.configName = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "Keyd configuration name";
    };
  };

  config = {
    flake.nixosModules.keyd = { pkgs, ... }: {

      # The keyd systemd service runs as root. It captures your input events,
      # remaps them, and emits them to the system at a low level.
      services.keyd.enable = true;

      environment = {
        systemPackages = [
          # Required to debug keycodes with `sudo keyd monitor`
          pkgs.keyd # Key remapping daemon for Linux
        ];

        # Keyd config files
        etc."keyd".source = ./configs/${config.mynix.keyd.configName};
      };
    };
  };
}
