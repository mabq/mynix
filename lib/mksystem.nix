{
  self,
  inputs,
  overlays,
}: {
  machine,
  system,
  user,
}: let
  # -- Additional arguments to automatically pass to all modules:
  #    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-flake-and-module-system#pass-non-default-parameters-to-submodules
  _args = {
    inherit self machine system user;
    pkgs-unstable = import inputs.nixpkgs-unstable {
      # -- Instantiate nixpkgs unstable, see https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
      inherit system; # -- must include `system` because of `import`, see https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
      config.allowUnfree = true;
    };
    # -- "Out of store" symlings:
    #    `config.lib.file.mkOutOfStoreSymlink` requires an absolute path to work
    #    correctly. This function creates a symlink to a file or directory outside
    #    the Nix store, and Nix expects the path to be absolute to ensure it can
    #    reliably resolve the target.
    # flakeRoot = self.sourceInfo.outPath; # -- abstract the location of the repository in the local system
    # flakeRoot = "/home/mabq/projects/nixos-setup/"; # -- abstract the location of the repository in the local system
    # flakeRoot = toString ./.; # expands to absolute path of the flake root
    flakeRoot = builtins.toPath (builtins.dirOf (builtins.toString ./.)); # expands to absolute path of the flake root
  };

  # -- Paths to include based on machine and user names:
  _machineNixosConfig = ../machines/${machine}/nixos.nix;
  _userNixosConfig = ../users/${user}/nixos.nix;
  _homeManagerConfig = ../users/${user};
in
  inputs.nixpkgs.lib.nixosSystem {
    # -- Pass these args to all NixOS modules:
    specialArgs = _args;

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

      _machineNixosConfig
      _userNixosConfig

      # -- Home Manager as a module of NixOS:
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        # -- Pass these args to all Home-manager modules - https://home-manager.dev/manual/24.11/#sec-flakes-nixos-module
        home-manager.extraSpecialArgs = _args;
        home-manager.users.${user} = import _homeManagerConfig;
      }
    ];
  }
