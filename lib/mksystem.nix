{
  inputs,
  overlays,
}: {
  machine,
  system,
  user,
}: let
  # -- "Out of store" symlinks:
  #    In order to reflect changes in configuration files inmediately we need
  #    to create "out-of-store" symlinks passing an **absolute** path to
  #    `config.lib.file.mkOutOfStoreSymlink`.
  #    These dynamic options cause the link to be owned by `root`:
  #      `flakeRoot = self.sourceInfo.outPath;`          # -- does not work
  #      `flakeRoot = toString ./.;`                     # -- does not work
  #    So I ended up hardcoding the path here. If you clone the repository into
  #    another directory you need to update this value.
  flakeRoot = "/home/${user}/.local/share/mynix";

  # -- Instantiate nixpkgs unstable:
  #    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
  pkgs-unstable = import inputs.nixpkgs-unstable {
    # -- Must include `system` because of `import`
    #    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
    inherit system;
    config.allowUnfree = true;
  };

  # -- Additional arguments I need in NixOS and Home-manager modules:
  #    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
  specialArgs = {
    inherit machine system user flakeRoot pkgs-unstable;
  };

  # -- Paths to include based on machine and user names:
  machineNixosConfig = ../machines/${machine}/nixos.nix;
  userNixosConfig = ../users/${user}/nixos.nix;
  homeManagerConfig = ../users/${user};
in
  inputs.nixpkgs.lib.nixosSystem {
    # -- Pass these args to all NixOS modules:
    inherit specialArgs;

    modules = [
      {
        # -- Prepare `pkgs`:
        #    Do it here to avoid passing `overlays` around.
        #    `pkgs` is the result of applying these configurations to `nixpkgs`.
        nixpkgs = {
          hostPlatform = system;
          overlays = overlays;
          config.allowUnfree = true;
        };
      }

      machineNixosConfig
      userNixosConfig

      inputs.home-manager.nixosModules.home-manager
      {
        # -- Pass these args to all Home-manager modules:
        #    https://home-manager.dev/manual/24.11/#sec-flakes-nixos-module
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.${user} = import homeManagerConfig;
      }
    ];
  }
