{ self, config, ... }:
let
  inherit (config.mynix) host user;
in
{
  flake.nixosModules."hosts-${host}" = {
    imports = [
      ./_hardware-configuration.nix
      self.nixosModules."users-${user}"
      self.nixosModules.atuin
      self.nixosModules.bare
      self.nixosModules.bat
      self.nixosModules.btop
      self.nixosModules.git
      self.nixosModules.keyd
      self.nixosModules.networkd
      self.nixosModules.sops
      self.nixosModules.starship
      self.nixosModules.tmux
      self.nixosModules.yazi
      self.nixosModules.zram
      self.nixosModules.zsh
    ];
  };
}
