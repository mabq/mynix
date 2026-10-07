{ lib, config, ... }:
{
  options = {

    mynix.swap.size = lib.mkOption {
      type = lib.types.int;
      default = 4096; # size in MB
      description = "Swapfile size in MB";
    };

  };

  config = {

    flake.nixosModules.swap = {
      swapDevices = [
        {
          size = config.mynix.swap.size;
          device = "/var/lib/swapfile";
          priority = 5; # lower priority than zram
        }
      ];
    };

  };
}
