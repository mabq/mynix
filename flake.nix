{
  description = "mabq NixOS flake setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
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

  outputs = inputs@{
    self,
    nixpkgs,
    ...
  }:
  let
    overlays = []; # -- See https://github.com/mitchellh/nixos-config/blob/abf96c785af158021bab59af969b7ec5ceda2f7f/flake.nix#L64
    mkSystem = import ./lib/mksystem.nix {
      inherit nixpkgs overlays inputs;
    };
  in {
    nixosConfigurations."nuc" = mkSystem {
      machine = "GB-BXi3-5010";
      system = "x86_64-linux";
      user = "mabq";
    };
  };
}
