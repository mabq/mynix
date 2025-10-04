{
  inputs,
  overlays,
}: {
  machine,
  system,
  user,
}: let
  # -- Out-of-store symlinks.
  #    I don't have the patience to wait for an entire re-build just to apply a
  #    simple configuration change, so I need to create symlinks that point out
  #    of the nix store, in order to do so I need to provide an absolute path,
  #    starting from the root of the system.
  #    When I used nix functions to programatically obtain the path of the
  #    flake, the resulting links where owned by `root`. For now just
  #    hard-code the path of the local repository here. Get used to always
  #    cloning it here (same as Omarchy).
  repo = "/home/${user}/.local/share/mynix";

  # -- Instantiate a new package set with the latest versions.
  #    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  # -- Make these arguments available in every NixOS and home-manager module.
  #    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
  specialArgs = {
    inherit machine system user repo pkgs-unstable;
  };
in
  inputs.nixpkgs.lib.nixosSystem {
    # -- Pass specialArgs to NixOS modules.
    inherit specialArgs;

    modules = [
      # -- Instantiate nixpkgs with the given options.
      {
        nixpkgs = {
          inherit system overlays;
          config.allowUnfree = true;
        };
      }

      # -- NixOS modules (paths are automatically imported).
      ../machines/${machine}
      ../users/${user}/nixos.nix

      # -- Home-manager as a NixOS module.
      #    https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
      inputs.home-manager.nixosModules.home-manager
      {
        # -- Use the same `pkgs` set that your NixOS system is using.
        #    Only applicable when using Home-manager as a NixOS module.
        home-manager.useGlobalPkgs = true;
        # -- Put home.packages in the user profile (`~/.nix-profile`), not
        #    on the system profile.
        #    Only applicable when using Home-manager as a NixOS module.
        home-manager.useUserPackages = true;
        # -- Import home-manager configuration.
        home-manager.users.${user} = import ../users/${user}/home.nix;
        # -- Pass specialArgs to home-manager modules.
        #    https://home-manager.dev/manual/24.11/#sec-flakes-nixos-module
        home-manager.extraSpecialArgs = specialArgs;
      }
    ];
  }
