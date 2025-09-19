{
  description = "mabq NixOS flake setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # -- TODO --
    
    # hyprland.url = "github:hyprwm/Hyprland";
    
    # nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    
    # -- Disk partitioning --
    # disko.url = "github:nix-community/disko";
    # disko.inputs.nixpkgs.follows = "nixpkgs";
    
    # -- Secrets --
    # sops-nix.url = "github:Mic92/sops-nix";
    # sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, ... }: let
    overlays = []; # -- be carefull, see https://nixos-and-flakes.thiscute.world/nixos-with-flakes/downgrade-or-upgrade-packages
    mkSystem = import ./lib/mksystem.nix {
      inherit inputs overlays;
    };
  in {
    nixosConfigurations."nuc" = mkSystem {
      machine = "GB-BXi3-5010";
      system = "x86_64-linux";
      user = "mabq";
    };
  };
}
