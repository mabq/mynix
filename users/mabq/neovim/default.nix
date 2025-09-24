{
  config,
  pkgs,
  pkgs-unstable,
  flakeRoot,
  ...
}: {
  # -- Create an "out of store" symlink to the configuration files
  home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${flakeRoot}/users/mabq/neovim/config";

  home.packages = [
    pkgs-unstable.neovim

    pkgs-unstable.lazygit

    pkgs.gnumake # -- required to build `fzf-native` for Telescope
    pkgs.clang # -- required to build treesitter parsers

    pkgs.lua-language-server # -- lua LSP
    pkgs.stylua # -- lua formatter

    pkgs.nixd # -- nix LSP
    pkgs.alejandra # -- nix formatter
  ];
}
