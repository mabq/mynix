{
  lib,
  inputs,
  config,
  ...
}:
let
  inherit (config.mynix) user theme;
  dir = "/home/${user}/.local/share/mynix/modules/programs/neovim";
in
{
  options = {

    mynix.neovim.configName = lib.mkOption {
      type = lib.types.str;
      default = user;
      description = "Neovim configuration name";
    };

  };

  config = {

    flake.nixosModules.neovim =
      let
        configName = config.mynix.neovim.configName;
      in
      { pkgs, ... }:
      {
        # The default Nix expression search path, used by the Nix evaluator to
        # look up paths enclosed in angle brackets (e.g. `<nixpkgs>`). Required
        # by nixd lsp config.
        nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

        # Make nvim the default text editor.
        # Read session variables notes in the default module for more information
        # about this option..
        environment.sessionVariables = {
          EDITOR = "nvim";
          SUDO_EDITOR = "nvim";
          VISUAL = "nvim";
        };

        environment.systemPackages = import ./configs/${configName}/_packages.nix pkgs;

        hjem.users.${user}.files = {
          ".config/nvim".source = "${dir}/configs/${configName}";
          ".config/mynix/theme/neovim.lua".source = "${dir}/themes/${theme}.lua";
        };
      };

  };
}
