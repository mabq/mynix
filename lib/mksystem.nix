inputs: {
  machine,
  user,
}: let
  pkgsConfig = {
    system = builtins.currentSystem;
    config.allowUnfree = true;
  };

  specialArgs = {
    inherit inputs machine user;

    # -- Out of store symlinks require an absolute path
    flakeRoot = "/home/${user}/.local/share/mynix";
    # TODO: Check if this works (only works on local flakes)
    # flakeRoot = inputs.self.sourceInfo.path;

    pkgs = import inputs.nixpkgs pkgsConfig;
    pkgsUnstable = import inputs.nixpkgs-unstable pkgsConfig;
  };

  machineConfig = ../machines/${machine};
  userNixos = ../users/${user}/nixos;
  userHome =
    inputs.home-manager.nixosModules.home-manager
    {
      # -- Use the same `pkgs` set that NixOS
      home-manager.useGlobalPkgs = true;
      # -- Put user packages in user user (`~/.nix-user`)
      home-manager.useUserPackages = true;
      home-manager.users.${user} = import ../users/${user}/home-manager;
      # -- Pass specialArgs to home manager modules
      home-manager.extraSpecialArgs = specialArgs;
    };
in
  inputs.nixpkgs.lib.nixosSystem {
    # -- Pass specialArgs to NixOS modules
    inherit specialArgs;
    modules = [
      machineConfig
      userNixos
      userHome
    ];
  }
