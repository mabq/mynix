{ lib, user, ... }:
{
  imports = [
    ./atuin.nix
    ./bat.nix
    ./btop.nix
    ./foot.nix
    ./git.nix
    ./neovim.nix
    ./starship.nix
    ./tmux.nix
    ./yazi.nix
    ./zsh.nix
  ];

  options = {

    mynix.programs.atuin = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable atuin";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [
          "default"
          "simple"
        ];
        default = "default";
        description = "atuin configuration name";
      };
    };

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

    mynix.programs.foot = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable foot";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [ "default" ];
        default = "default";
        description = "foot configuration name";
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
        default = "default";
        description = "git configuration name";
      };
    };

    mynix.programs.neovim = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable neovim";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [
          "default"
          "${user}"
        ];
        default = "default";
        description = "neovim configuration name";
      };
    };

    mynix.programs.starship = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable starship";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [
          "default"
          "simple"
        ];
        default = "default";
        description = "starship configuration name";
      };
    };

    mynix.programs.tmux = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable tmux";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [ "default" ];
        default = "default";
        description = "tmux configuration name";
      };
    };

    mynix.programs.yazi = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable yazi";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [ "default" ];
        default = "default";
        description = "yazi configuration name";
      };
    };

    mynix.programs.zsh = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to enable zsh";
      };
      configName = lib.mkOption {
        # Add future possible configurations here for type checking
        type = lib.types.enum [ "default" ];
        default = "default";
        description = "zsh configuration name";
      };
    };

  };

  # Configurations are set by imported modules.
}
