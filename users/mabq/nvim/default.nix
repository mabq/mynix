configName: {
  pkgs,
  pkgsUnstable,
  userPath,
  outlink,
  ...
}: let
  # - I might want to have different configuration sets in the future.
  configPath = "${userPath}/nvim/config/${configName}";
in {
  home.packages = [
    pkgsUnstable.neovim

    # - Yazi used in Neovim but it has its own module.

    # - Required by snacks (lazygit)
    pkgsUnstable.lazygit

    # - Required by telescope
    pkgs.gnumake # - to build `fzf-native`
    pkgs.ripgrep # - live_grep, grep_string
    pkgs.fd # - find_files

    # - Required by Treesitter
    pkgs.clang # - to buils parsers

    # - Lua language tools
    pkgs.lua-language-server
    pkgs.stylua

    # - Nix language tools
    pkgs.nixd
    pkgs.alejandra

    # - Bash language tools
    pkgs.bash-language-server
    pkgs.shfmt
  ];

  # - Link the entire config directory (out of store)
  home.file.".config/nvim".source = outlink "${configPath}";
}
