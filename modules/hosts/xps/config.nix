{ self, config, ... }:
let
  inherit (config.mynix) host user;
in
{
  config = {

    mynix = {
      host = "xps";
      stateVersion = "26.05";
      user = "mabq";
      email = "alejandro.banderas@me.com";
    };

    flake.nixosModules."hostConfig-${host}" = {
      imports = [
        ./_hardware-configuration.nix
        self.nixosModules."users-${user}"
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
        self.nixosModules.zsh
      ];
    };

  };
}
