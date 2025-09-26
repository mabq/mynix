{
  config,
  pkgs,
  pkgs-unstable,
  repo,
  ...
}: let
  outOfStore = config.lib.file.mkOutOfStoreSymlink;
  thisModule = "${repo}/modules/nvim";
in {
  home.packages = [
    pkgs-unstable.neovim

    pkgs-unstable.lazygit

    pkgs.gnumake # -- required by Telescope to build `fzf-native`
    pkgs.clang # -- required by Treesitter to build parsers

    pkgs.ripgrep # -- required by Telescope
    pkgs.fd # -- required by Telescope

    pkgs.lua-language-server
    pkgs.stylua

    pkgs.nixd
    pkgs.alejandra
  ];

  # Link the whole directory out-of-store so that no rebuild is required to apply changes (must be an absolute path)
  home.file.".config/nvim".source = outOfStore "${thisModule}/config";
}
