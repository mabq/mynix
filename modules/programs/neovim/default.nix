{ inputs, ... }:
{
  flake.nixosModules.neovim =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      inherit (config.mynix) user theme neovimConfig;
      dir = "/home/${user}/.local/share/mynix/modules/programs/neovim";
    in
    {

      options = {
        mynix.neovimConfig = lib.mkOption {
          type = lib.types.str;
          default = user;
          description = "Selected neovim configuration";
        };
      };

      config = {
        environment.systemPackages = import ./configs/${neovimConfig}/_packages.nix pkgs;

        hjem.users.${user}.files = {
          ".config/nvim".source = "${dir}/configs/${neovimConfig}"; # out of store
          ".config/mynix/theme/neovim.lua".source = "${dir}/themes/${theme}.lua"; # do not affect flake repo
        };

        # Make nvim the default text editor.
        # Read session variables notes in the default module for more information
        # about this option..
        environment.sessionVariables = {
          EDITOR = "nvim";
          SUDO_EDITOR = "nvim";
          VISUAL = "nvim";
        };

        # The default Nix expression search path, used by the Nix evaluator to
        # look up paths enclosed in angle brackets (e.g. `<nixpkgs>`). Required
        # by nixd lsp config.
        nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      };

    };
}
