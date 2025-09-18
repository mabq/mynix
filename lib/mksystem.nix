{ nixpkgs, overlays, inputs }:

{ machine, system, user }:

let
  machineNixosConfig = ../machines/${machine}/configuration.nix;
  userNixosConfig = ../users/${user}/nixos.nix;
  userHMConfig = ../users/${user};

in nixpkgs.lib.nixosSystem {

  # -- Pass additional attributes to all sub-modules.
  #    See https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
  specialArgs = { 
    inherit inputs;
    thisMachine = machine;
    thisSystem = system;
    thisUser = user;
  };

  modules = [
    # -- Define how `pkgs` is constructed:
    #    Do it here to avoid passong `overlays` around.
    #    `nixpkgs` is the content of the upstream repository untouched.
    #    `pkgs` is the result of applying our configurations to `nixpkgs` (system, overlays, config, etc).
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
      home-manager.users.${user} = import userHMConfig {
        inputs = inputs;
      };
    }
  ];

}
