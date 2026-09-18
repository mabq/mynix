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
      };
    };
}

/*
  [1]

  The nixpkgs channel used by this flake. You can find all available
  branches in:

    `https://channels.nixos.org/`

  The ones starting with `nixos-*` are the ones that include NixOS integration
  testings and therefore the ones you should use here.

  For the status of all branches, see: `https://status.nixos.org`.

  [2]

  The home-manager branch to be used by this flake.

  We explicitly use the `master` branch since that is the branch that is tested
  against the "unstable" branches of nixpkgs.

  If you ever change the `nixpkgs` branch to some fixed version like `26.06`
  you should also change the home-manager branch to match that one.

  [3]

  Force the flake to use the same nixpkgs branch used in this flake.

  This is recommended for most input flakes, but that is now always the case.
  Ask AI whether you should do this for any new input flakes you add.

  [4]

  The nixos configuration name is passed to the `nixos-rebuild` command to
  target a specific configuration.

    `sudo nixos-rebuild --flake .#<CONFIGURATION-NAME>`

  The attributes, on the other hand, are used to target configuration files.
*/
