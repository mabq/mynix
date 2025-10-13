{
  inputs,
  config,
  pkgs,
  flakePath,
  user,
  ...
}: let
  # --- Put the user settings here ---
  theme = "tokyo-night";
in {
  # - Make the following arguments available to all home-manager modules.
  _module.args = {
    userPath = "${flakePath}/users/${user}";
    outlink = config.lib.file.mkOutOfStoreSymlink;
    pkgsUnstable = import inputs.nixpkgs-unstable {
      # - Reuse the main package set configuration options
      system = pkgs.system;
      config = pkgs.config;
    };
  };

  imports = [
    (import ./themes theme)
    (import ./nvim "mabq")
    ./tmux
    ./yazi
    ./zsh
    ./starship
    ./age
    ./ssh
    ./git
    ./lazygit
  ];

  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  # Packages I always want installed. Most packages I install using per-project
  # flakes sourced with direnv and nix-shell, so this is not a huge list.
  # home.packages = [
  #   pkgs.btop
  #
  #   pkgs.bitwarden-desktop
  #   pkgs._1password-cli
  #   pkgs.asciinema
  #   chezmoi
  #   pkgs.gh
  #   pkgs.sentry-cli
  #   pkgs.watch
  #
  #   pkgs.jq
  #
  #   pkgs.gopls
  #   pkgs.zigpkgs."0.14.0"
  #
  #   pkgs.claude-code
  #   pkgs.codex
  #
  #   Node is required for Copilot.vim
  #   pkgs.nodejs
  #
  #   pkgs.chromium
  #   pkgs.firefox
  #   pkgs.rofi
  #   pkgs.valgrind
  #   pkgs.zathura
  #   pkgs.xfce.xfce4-terminal
  #
  #   pkgs.pciutils # lspci
  #   pkgs.usbutils # lsusb
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
