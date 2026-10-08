{ self, config, ... }:
let
  inherit (config.mynix) host user;
in
{
  flake.nixosModules."hosts-${host}" = { pkgs, ... }: {

    imports = [
      ./_hardware.configuration.nix
      self.nixosModules.bare
      self.nixosModules.bat
      self.nixosModules.btop
      self.nixosModules.keyd
      self.nixosModules.networkd
      self.nixosModules.zram
      self.nixosModules.tmux
      self.nixosModules.yazi
      self.nixosModules.zsh
      self.nixosModules."users-${user}"
    ];

  };
}
