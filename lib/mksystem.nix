inputs: {
  host,
  user,
}: let
  specialArgs = {
    inherit inputs host user;
    flakePath = "/home/${user}/.local/share/mynix";
  };
in
  inputs.nixpkgs.lib.nixosSystem {
    inherit specialArgs;
    modules = [
      # - Host configurations
      ../hosts/${host}

      # - User system configurations
      ../users/${user}/system.nix

      # - User home configurations
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = specialArgs;
        home-manager.users.${user} = import ../users/${user}/home.nix;
      }
    ];
  }
