# These options should be set in the host config file, not in the profile.
{ lib, ... }:
{
  imports = [
    ./memory/zram.nix
    ./memory/swap.nix
  ];

  options = {
    mynix.hardware.memory.zram = {
      enable = lib.mkEnableOption "Whether to enable zram"; # disabled by default
      algorithm = lib.mkOption {
        type = lib.types.enum [
          "lz4"
          "zstd"
        ];
        default = "lz4";
        description = "Compression algorithm to use (see module notes)";
      };
      percentage = lib.mkOption {
        type = lib.types.ints.between 20 80;
        default = 50;
        description = "Maximum total amount of memory that can be stored in the zram swap devices (as a percentage of your total memory).";
      };
    };

    mynix.hardware.memory.swap = {
      enable = lib.mkEnableOption "Whether to create a swap file"; # disabled by default
      size = lib.mkOption {
        type = lib.types.ints.between 1024 8192;
        default = 4096;
        description = "Swap file size in MiB";
      };
    };
  };

  # Configurations are set by imported modules.
}
