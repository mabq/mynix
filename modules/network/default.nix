{ lib, ... }:
{
  imports = [
    ./networkmanager.nix
    ./systemd-networkd.nix
    ./systemd-resolved.nix
  ];

  options = {
    mynix.network.manager = lib.mkOption {
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
