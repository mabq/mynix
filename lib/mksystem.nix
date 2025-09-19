{ inputs, overlays }:

{ machine, system, user }: let

  machineNixosConfig = ../machines/${machine}/nixos.nix;
  userNixosConfig = ../users/${user}/nixos.nix;
  homeManagerConfig = ../users/${user}/home-manager.nix;

  pkgs-unstable = import inputs.nixpkgs-unstable {
    hostPlatform = system;
    config.allowUnfree = true;
  };

in inputs.nixpkgs.lib.nixosSystem {

  # -- Pass additional attributes to all nixos modules.
  #    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
  specialArgs = { 
    inherit inputs pkgs-unstable;
    thisMachine = machine;
    thisSystem = system;
    thisUser = user;
  };

  modules = [
    # -- Define how `pkgs` is constructed:
    #    Do it here to avoid passing `overlays` around.
    #    `nixpkgs` is the content of the upstream repository untouched.
    #    `pkgs` is the result of applying our customizations to `nixpkgs` (system, overlays, config, etc).
    #    `pkgs` is automatically passed to all submodules.
    {
      nixpkgs = { 
	hostPlatform = system;
        overlays = overlays;
	config.allowUnfree = true;
      };
    }

    # -- Paths are automatically imported by the module system.
    machineNixosConfig
    userNixosConfig

    # -- Home Manager as a module of NixOS:
    inputs.home-manager.nixosModules.home-manager {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import homeManagerConfig {
	# -- Pass additional attributes to home-manager modules
	inherit inputs pkgs-unstable;
      };
    }
  ];

}
