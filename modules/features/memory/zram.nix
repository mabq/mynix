{ lib, config, ... }:
{
  options = {

    mynix.zram = {
      algorithm = lib.mkOption {
        # To see which algorithms your kernel supports, use:
        #   `cat /sys/block/zram0/comp_algorithm`
        # The algorithm currently in use is shown in [square brackets]
        type = lib.types.enum [
          "lz4" # low compression rate (~1.5/2 to 1), low cpu usage
          "zstd" # higher compression rate (~3 to 1), moderate cpu usage
        ];
        default = "lz4";
        description = "zram compression algorithm";
      };

      percentage = lib.mkOption {
        # Maximum total amount of memory that can be stored in the zram swap
        # devices (as a percentage of your total memory). Defaults to 1/2 of
        # your total RAM. Run `zramctl` to check how good memory is compressed.
        type = lib.types.int;
        default = 50;
        description = "Percentage of total memory to compress";
      };
    };

  };

  config = {

    flake.nixosModules.zram = {
      zramSwap = {
        enable = true;
        priority = 100; # prioritize zram over swap
        algorithm = config.mynix.zram.algorithm;
        memoryPercent = config.mynix.zram.percentage;
      };
    };

  };
}
