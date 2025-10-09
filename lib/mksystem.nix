inputs: {
  machine,
  user,
  # system,
}: let
  moduleArgs = import ./moduleArgs.nix {
    # inherit inputs machine user system;
    inherit inputs machine user;
  };
  machineConfig = ../machines/${machine};
  userNixos = ../users/${user}/nixos.nix;
  # userHomeManager =
  #   inputs.home-manager.nixosModules.home-manager
  #   {
  #     # Use the same pkgs set as NixOS.
  #     home-manager.useGlobalPkgs = true;
  #     # Put user packages in `/etc/profiles`.
  #     home-manager.useUserPackages = true;
  #     home-manager.users.${user} = import ../users/${user}/home-manager.nix;
  #     # Make specialArgs available to all home-manager modules.
  #     # home-manager.extraSpecialArgs = specialArgs;
  #   };
in
  inputs.nixpkgs.lib.nixosSystem {
    # # Make specialArgs available in all NixOS modules.
    # inherit specialArgs;
    modules = [
      moduleArgs
      machineConfig
      userNixos
      # userHomeManager
    ];
  }
