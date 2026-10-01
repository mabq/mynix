{ lib, ... }:
{
  imports = [
    ./memory/zram.nix
    ./memory/swap.nix

    ./network/networkmanager.nix
    ./network/systemd-networkd.nix
    ./network/systemd-resolved.nix
  ];

  # Use these options in the host file (not in the profile file)
  options = {
    mynix.hardware.memory.zram = {
      enable = lib.mkEnableOption "Whether to enable zram"; # disabled by default
      algorithm = lib.mkOption {
        type = lib.types.enum [
          "lz4"
          "zstd"
        ];
        default = "lz4";
        description = "Zram compression algorithm (see module notes)";
      };
      percentage = lib.mkOption {
        type = lib.types.ints.between 20 80;
        default = 50;
        description = "Maximum total amount of memory that can be stored in the zram swap devices (as a percentage of your total memory)";
      };
    };

    mynix.hardware.memory.swap = {
      enable = lib.mkEnableOption "Whether enable swap"; # disabled by default
      size = lib.mkOption {
        type = lib.types.ints.between 1024 8192;
        default = 4096;
        description = "Swap file size in MiB";
      };
    };

    mynix.hardware.network.manager = lib.mkOption {
      type = lib.types.enum [
        "networkmanager"
        "systemd"
      ];
      default = "networkmanager";
      description = "System network manager";
    };
  };

  # Configurations are set by imported modules.
}
