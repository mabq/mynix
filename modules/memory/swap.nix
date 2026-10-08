{ lib, config, ... }:
{
  options = {
    mynix.swap.size = lib.mkOption {
      type = lib.types.int;
      default = 4;
      description = "Swapfile size in GB";
    };
  };

  config = {
    flake.nixosModules.swap = {
      swapDevices = [
        {
          size = config.mynix.swap.size * 1024;
          device = "/var/lib/swapfile";
          priority = 5; # lower priority than zram
        }
      ];
    };
  };
}
