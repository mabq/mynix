{
  config,
  pkgs,
  pkgs-unstable,
  repo,
  ...
}: let
  _outOfStore = config.lib.file.mkOutOfStoreSymlink;
  _config = "${repo}/modules/nvim/config";
in {
  home.packages = [
    pkgs-unstable.neovim

    pkgs-unstable.lazygit

    pkgs.gnumake # Required by Telescope to build `fzf-native`
    pkgs.clang # Required by Treesitter to build parsers

    pkgs.ripgrep # Required by Telescope
    pkgs.fd # Required by Telescope

    pkgs.lua-language-server
    pkgs.stylua

    pkgs.nixd
    pkgs.alejandra

    pkgs.bash-language-server
    pkgs.shfmt
  ];

  # Link the whole directory out-of-store so that no rebuild is required to apply changes (must be an absolute path)
  home.file.".config/nvim".source = _outOfStore "${_config}";
}
