# This is not a module. Cannot use automatically injected arguments here!
inputs: {
  host,
  user,
  theme ? "tokyo-night",
}: let
  specialArgs = rec {
    inherit inputs host user theme;
    # - Out of store symlinks require absolute paths.
    flakePath = "/home/${user}/.local/share/mynix";
    configPath = "${flakePath}/users/${user}/config";
  };
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules = [
      ../hosts/${host} # - Host configurations
      ../users/${user}/nixos.nix # - User system configurations

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users.${user} = import ../users/${user}/home-manager.nix; # - Home-manager configurations
      }
    ];
  }
