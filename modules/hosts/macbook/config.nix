{ self, config, ... }:
let
  inherit (config.mynix) host user;
in
{
  flake.nixosModules."${host}-config" = { pkgs, ... }: {

    imports = [
      ./_hardware.configuration.nix
      self.nixosModules.bare
      self.nixosModules.networkd
      self.nixosModules.keyd
    ];

    users.users.${user} = {
      extraGroups = [ "wheel" ];
      hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01";
    };

    environment.systemPackages = with pkgs; [
      just # Handy way to save and run project-specific commands
      # age # Modern encryption tool with small explicit keys
      yazi # Blazing fast terminal file manager written in Rust, based on async I/O
      neovim # Vim text editor fork
      gh # CLI GitHub tool (authenticate from the terminal)
      git # Distributed version control system
      lazygit # Simple terminal UI for git commands
    ];

  };
}
