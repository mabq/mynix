{
  config,
  pkgs,
}: let
  theme = "tokyo-night";
in {
  imports = [
    (import ./themes theme) 
    # ./zsh
    # ./starship
    # ./tmux
    # ./yazi
    # ./nvim
    # ./age
    # ./ssh
  ];

  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  # Packages I always want installed. Most packages I install using per-project
  # flakes sourced with direnv and nix-shell, so this is not a huge list.
  # home.packages = [
  #   pkgs.just            <<<<<<<<<<<<<<
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

  # programs.git = {
  #   enable = true;
  #   userName = "Alejandro Banderas";
  #   userEmail = "alejandro.banderas@me.com";
  #   # signing = {
  #   #   key = "523D5DC389D273BC";
  #   #   signByDefault = true;
  #   # };
  #   # aliases = {
  #   #   cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
  #   #   prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
  #   #   root = "rev-parse --show-toplevel";
  #   # };
  #   extraConfig = {
  #     # branch.autosetuprebase = "always";
  #     color.ui = true;
  #     core.askPass = ""; # needs to be empty to use terminal for ask pass
  #     # credential.helper = "store"; # want to make this more secure
  #     github.user = "mabq";
  #     # push.default = "tracking";
  #     init.defaultBranch = "main";
  #   };
  # };

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
