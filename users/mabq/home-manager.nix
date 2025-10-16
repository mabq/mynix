{
  inputs,
  config,
  pkgs,
  ...
}: {
  # - Make the following arguments available to all home-manager modules.
  #   These cannot be placed in `mksystem` cause it is not a module, it has
  #   no access to `config` or `pkgs`.
  _module.args = {
    outlink = config.lib.file.mkOutOfStoreSymlink;
    pkgsUnstable = import inputs.nixpkgs-unstable {
      # - Reuse the main package set configuration options
      system = pkgs.system;
      config = pkgs.config;
    };
  };

  imports = [
    ./install.nix
    ./files.nix
    ./services.nix
  ];

  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  # home.packages = [
  #   pkgs.bitwarden-desktop
  #   pkgs._1password-cli
  #   pkgs.asciinema
  #   chezmoi
  #   pkgs.sentry-cli
  #   pkgs.watch
  #
  #   pkgs.gopls
  #   pkgs.zigpkgs."0.14.0"
  #
  #   pkgs.claude-code
  #   pkgs.codex
  #
  #   pkgs.nodejs
  #
  #   pkgs.chromium
  #   pkgs.firefox
  #   pkgs.rofi
  #   pkgs.valgrind
  #   pkgs.zathura
  #   pkgs.xfce.xfce4-terminal
  # ];

  # xdg.enable = true;

  # home.sessionVariables = {
  # -- These are set in the shell config files:
  # LANG = "en_US.UTF-8";
  # LC_CTYPE = "en_US.UTF-8";
  # LC_ALL = "en_US.UTF-8";
  # EDITOR = "nvim";
  # PAGER = "less -FirSwX";
  # MANPAGER = "/bin/manpager";

  # programs.direnv= {
  #   enable = true;
  #
  #   config = {
  #     whitelist = {
  #       prefix= [
  #         "$HOME/code/go/src/github.com/hashicorp"
  #         "$HOME/code/go/src/github.com/mitchellh"
  #       ];
  #
  #       exact = ["$HOME/.envrc"];
  #     };
  #   };
  # };

  # xresources.extraConfig = builtins.readFile ./Xresources;

  # ----------------------------------------------------------------------------
  # Do not edit!
  # ----------------------------------------------------------------------------

  home.stateVersion = "25.05"; # do not edit! not even when updating!
}
