{
  description = "NixOS setup";

  inputs = {
    # - Must be a nixos branch to include NixOS modules.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

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
    mkSystem = import ./lib/mksystem.nix inputs;
  in {
    nixosConfigurations = {
      "nuc" = mkSystem {
        host = "GB-BXi3-5010";
        user = "mabq";
      };
    };
  };
}
