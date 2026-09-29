{ lib, ... }:
{
  imports = [
    ./dependencies/systemd-networkd.nix
    ./dependencies/networkmanager.nix
  ];

  options = {
    mynix.network.manager = lib.mkOption {
      type = lib.types.enum [
        "networkmanager"
        "systemd"
      ];
      default = "networkmanager";
      example = "systemd";
      description = "The system network manager.";
    };
  };

  config = {
    # Configurations are set by imported modules.
  };
}
