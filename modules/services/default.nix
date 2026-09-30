{ lib, ... }:
{
  imports = [
    ./keyd.nix
    ./openssh.nix
    ./plex.nix
    ./tailscale.nix
  ];

  options = {
    mynix.services.keyd = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable keyd";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [ "default" ];
        default = "default";
        description = "keyd configuration name";
      };
    };

    mynix.services.openssh.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable openssh";
    };

    mynix.services.plex = {
      enable = lib.mkEnableOption "Whether to enable plex";
    };

    mynix.services.tailscale.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable tailscale";
    };

  };

  # Configurations are set by imported modules.
}
