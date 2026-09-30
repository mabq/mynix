{ lib, user, ... }:
{
  imports = [
    ./bat.nix
    ./btop.nix
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

    mynix.programs.btop = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable btop";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [ "default" ];
        default = "default";
        description = "btop configuration name";
      };
    };

    mynix.programs.git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable git";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [
          "default"
          "${user}"
        ];
        default = "${user}";
        description = "git configuration name";
      };
    };
  };

  # Configurations are set by imported modules.
}
