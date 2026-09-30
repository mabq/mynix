{ lib, ... }:
{
  imports = [
    ./bat.nix
  ];

  options = {
    mynix.programs.bat = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable bat";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [ "default" ];
        default = "default";
        description = "bat configuration name";
      };
    };
  };

  # Configurations are set by imported modules.
}
