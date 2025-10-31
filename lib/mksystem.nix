# - This is not a module.
#   No automatically injected arguments here!
{
  inputs,
  self,
}: {
  host,
  user,
  profile,
  theme ? "tokyo-night",
}: let
  specialArgs = rec {
    inherit inputs self host user profile theme;
    # - Out of store symlinks require absolute paths.
    flakePath = "/home/${user}/.local/share/mynix";
    configPath = "${flakePath}/users/${user}/config";
  };
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules = [
      ../hosts/${host}

      ../users/${user}/${profile}/nixos.nix

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
        # home-manager.users.${user} = import ../users/${user}/home-manager.nix; # - Home-manager configurations
        home-manager.users.${user} = import ../users/${user}/${profile}/homeManager.nix; # - Home-manager configurations
      }
    ];
  }
