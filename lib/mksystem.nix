{
  inputs,
  overlays,
}: {
  machine,
  system,
  user,
}: let
  # Out-of-store symlinks require an absolute path
  repo = "/home/${user}/.local/share/mynix";

  pkgs-unstable = import inputs.nixpkgs-unstable {
    # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
    inherit system;
    config.allowUnfree = true;
  };

  specialArgs = {
    # https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
    inherit machine system user repo pkgs-unstable;
  };
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;

    modules = [
      {
        nixpkgs = {
          hostPlatform = system;
          overlays = overlays;
          config.allowUnfree = true;
        };
      }
      # paths are automatically imported
      ../machines/${machine} # nixos machine config
      ../users/${user}/nixos.nix # nixos user config
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.extraSpecialArgs = specialArgs; # https://home-manager.dev/manual/24.11/#sec-flakes-nixos-module
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import ../users/${user}; # home manager config
      }
    ];
  }
