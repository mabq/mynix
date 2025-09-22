{
  config,
  user,
  pkgs,
  pkgs-unstable,
  ...
}: let
  configPath = "${config.home.homeDirectory}/.nixos-setup/users/${user}/home/neovim/config/mabq";
in {
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configPath;

  home.packages = [
    # Telescope:
    pkgs.gnumake # -- required to build `fzf-native`.

    # Treesitter:
    pkgs.clang # -- required to build parsers.

    # Lua LSP and formatter:
    pkgs.lua-language-server
    pkgs.stylua

    # Nix LSP and formatter:
    pkgs.nixd
    pkgs.alejandra

    # Lazygit:
    pkgs-unstable.lazygit

    # Neovim:
    pkgs-unstable.neovim
  ];
}
