{
  description = "My nixos configs";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable"; # [1]
    };

    home-manager = {
      url = "github:nix-community/home-manager/master"; # [2]
      inputs.nixpkgs.follows = "nixpkgs"; # [3]
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, ... }@inputs:
    let
      mkSystem = import ./lib/mkSystem.nix { inherit self inputs; };
    in
    {
      # [4]
      nixosConfigurations = {
        "xps" = mkSystem {
          host = "xps";
          user = "mabq";
          profile = "plex-server";
          repoBranch = "restructure";
        };
        "macbook" = mkSystem {
          host = "macbook";
          user = "mabq";
          profile = "plex-server";
          repoBranch = "restructure";
        };
      };
    };
}

/*
  [1]

  The version of nixpkgs used by this flake. You can find all available
  branches in:

    https://channels.nixos.org/

  The ones starting with `nixos-*` are the ones that include NixOS integration
  testings and therefore the ones you should use here.

  For the status of all branches, see:
    https://status.nixos.org

  To update flake inputs, watch:
    https://www.youtube.com/watch?v=fLICrNK_COw

  [2]

  The home-manager branch to be used by this flake.

  We explicitly use the `master` branch since that is the branch that is tested
  against the "unstable" branches of nixpkgs.

  If you ever change the `nixpkgs` branch to some fixed version like `26.06`
  you should also change the home-manager branch to match that one.

  [3]

  Force the flake input to use the same version of nixpkgs as this flake.

  For more information, watch:
    https://youtu.be/JCeYq72Sko0?t=705

  [4]

  The nixos configuration name is passed to the `nixos-rebuild` command to
  target a specific configuration.

    `sudo nixos-rebuild --flake .#<CONFIGURATION-NAME>`

  The attributes, on the other hand, are used to target configuration files.
*/
