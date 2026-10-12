{ self, config, ... }:
{
  flake.nixosModules."hosts-macbook" = {

    mynix = {
      host = "macbook";
      stateVersion = "26.05";
      user = "mabq";
      email = "alejandro.banderas@me.com";
    };

    imports = [
      ./_hardware-configuration.nix
      self.nixosModules."users-mabq"
      self.nixosModules.atuin
      self.nixosModules.base
      self.nixosModules.bat
      self.nixosModules.btop
      self.nixosModules.git
      self.nixosModules.keyd
      self.nixosModules.neovim
      self.nixosModules.networkd
      self.nixosModules.openssh
      self.nixosModules.sops
      self.nixosModules.starship
      self.nixosModules.tmux
      self.nixosModules.yazi
      self.nixosModules.zram
      self.nixosModules.zsh
    ];

  };
}
