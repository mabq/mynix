{
  description = "mynix - My NixOS and Home-manager setup";

  inputs = {
    # -- Nixpkgs branch:
    #    The branch `nixpkgs-<version>` contains all Nix packages, but no
    #    NixOS-specific modules, it is meant to be used in non-NixOS systems
    #    (like Arch). For all nixpkgs + all NixOS modules use the
    #    `nixos-<version>` branch.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # -- Home-manage branch:
    #    Make sure you use the same release as nixpkgs.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # hyprland.url = "github:hyprwm/Hyprland";

    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    # disko.url = "github:nix-community/disko";
    # disko.inputs.nixpkgs.follows = "nixpkgs";

    # sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {...}: let
    # -- Overlays:
    #    Override a package and make that change visible to all other
    #    packages depending on it. For more information see:
    #    https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
    overlays = [];
    mkSystem = import ./lib/mksystem.nix {
      inherit inputs overlays;
    };
  in {
    nixosConfigurations = {
      "nuc" = mkSystem {
        machine = "GB-BXi3-5010";
        system = "x86_64-linux";
        user = "mabq";
      };
    };
  };
}
