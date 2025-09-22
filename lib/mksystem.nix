{
  inputs,
  overlays,
}: {
  machine,
  system,
  user,
}: let
  # -- Instanciate nixpkgs unstable:
  #    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system; # -- must include `system` because of `import`, see https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
    config.allowUnfree = true;
  };

  # -- Additional arguments to automatically pass to all modules:
  #    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
  extraArgs = {inherit inputs machine system user pkgs-unstable;};

  # -- Paths to include based on machine and user names:
  machineNixosConfig = ../machines/${machine}/nixos.nix;
  userNixosConfig = ../users/${user}/nixos.nix;
  homeManagerConfig = ../users/${user}/home;
in
  inputs.nixpkgs.lib.nixosSystem {
    # -- Pass these args to all NixOS modules:
    specialArgs = extraArgs;

    modules = [
      # -- Prepare `pkgs` - do it here to avoid passing `overlays` around:
      #    `nixpkgs` is the content of the upstream repository untouched.
      #    `pkgs` is the result of applying our customizations those packages (system, overlays, config, etc).
      #    `pkgs` is automatically passed to all submodules, not `nixpkgs`.
      {
        nixpkgs = {
          hostPlatform = system;
          overlays = overlays;
          config.allowUnfree = true;
        };
      }

      machineNixosConfig
      userNixosConfig

      # -- Home Manager as a module of NixOS:
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        # -- Pass these args to all Home-manager modules - https://home-manager.dev/manual/24.11/#sec-flakes-nixos-module
        home-manager.extraSpecialArgs = extraArgs;
        home-manager.users.${user} = import homeManagerConfig;
      }
    ];
  }
