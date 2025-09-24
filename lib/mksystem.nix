{
  self,
  inputs,
  overlays,
}: {
  machine,
  system,
  user,
}: let
  # -- "Out of store" symlings:
  #    In order to reflect changes in configuration files inmediately we need
  #    to create symlinks out of the nix store. In order to do that we need to
  #    provide an absolute path to `config.lib.file.mkOutOfStoreSymlink`.
  #    I tried all sorts of things to dynamically get the root of the flake
  #    but all those ended up evaluating as root, therefore creating the
  #    symlinks with `root` as owner.
  # flakeRoot = self.sourceInfo.outPath;    # -- does not work
  # flakeRoot = toString ./.;               # -- does not work
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
        home-manager.users.${user} = import homeManagerConfig;
        # -- Pass these args to all Home-manager modules:
        #    https://home-manager.dev/manual/24.11/#sec-flakes-nixos-module
        home-manager.extraSpecialArgs = specialArgs;
      }
    ];
  }
