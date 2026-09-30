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
      description = "The system network manager.";
    };
  };

  # Configurations are set by imported modules.
}
