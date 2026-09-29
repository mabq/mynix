{ lib, ... }:
{
  imports = [
    ./networkmanager.nix
    ./openssh.nix
    ./systemd-networkd.nix
    ./systemd-resolved.nix
    ./tailscale.nix
  ];

  options = {
    mynix.network = {

      manager = lib.mkOption {
        type = lib.types.enum [
          "networkmanager"
          "systemd"
        ];
        default = "networkmanager";
        example = "systemd";
        description = "The system network manager.";
      };

      tailscale.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Whether to enable tailscale";
      };

      openssh.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        example = false;
        description = "Whether to enable openssh";
      };

    };
  };

  config = {
    # Configurations are set by imported modules.
  };
}
