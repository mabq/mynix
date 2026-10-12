{
  flake.nixosModules.swap = { config, lib, ... }: {

    options = {

      mynix.swapSize = lib.mkOption {
        type = lib.types.int;
        default = 4;
        description = "Swapfile size in GB";
      };

    };

    config = {

      swapDevices = [
        {
          size = config.mynix.swapSize * 1024;
          device = "/var/lib/swapfile";
          priority = 5; # lower priority than zram
        }
      ];

    };

  };
}
