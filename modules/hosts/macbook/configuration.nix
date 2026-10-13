{ self, inputs, ... }:
let
  mynix = {
    host = "macbook";
    stateVersion = "26.05";
  };
in
{
  flake.nixosConfigurations.${mynix.host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      {
        inherit mynix;
      }
      ./_hardware-configuration.nix
      self.nixosModules.atuin
      self.nixosModules.audio
      self.nixosModules.base
      self.nixosModules.bat
      self.nixosModules.btop
      self.nixosModules.cliamp
      self.nixosModules.git
      self.nixosModules.keyd
      self.nixosModules.neovim
      self.nixosModules.networkd
      self.nixosModules.openssh
      self.nixosModules.plex
      self.nixosModules.sops
      self.nixosModules.starship
      self.nixosModules.tailscale
      self.nixosModules.tmux
      self.nixosModules.users-mabq
      self.nixosModules.yazi
      self.nixosModules.zram
      self.nixosModules.zsh
    ];
  };
}
