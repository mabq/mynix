{pkgs, ...}: let
  # User settings.
  theme = "tokyo-night";

  # These are just local variables.
  myNixSetup = import ../../modules/themes theme;
in {
  imports = [
    myNixSetup
    ../../modules/zsh
    ../../modules/starship
    ../../modules/tmux
    ../../modules/yazi
    ../../modules/nvim
    ../../modules/age
    ../../modules/ssh
  ];

  # Packages I always want installed. Most packages I install using per-project
  # flakes sourced with direnv and nix-shell, so this is not a huge list.
  home.packages = [
    pkgs.just
    # pkgs.btop

    # pkgs.bitwarden-desktop
    # pkgs._1password-cli
    # pkgs.asciinema
    # chezmoi
    # pkgs.gh
    # pkgs.sentry-cli
    # pkgs.watch

    # pkgs.jq

    # pkgs.gopls
    # pkgs.zigpkgs."0.14.0"

    # pkgs.claude-code
    # pkgs.codex

    # Node is required for Copilot.vim
    # pkgs.nodejs

    # pkgs.chromium
    # pkgs.firefox
    # pkgs.rofi
    # pkgs.valgrind
    # pkgs.zathura
    # pkgs.xfce.xfce4-terminal

    # pkgs.pciutils # lspci
    # pkgs.usbutils # lsusb
  ];

  # ---------------------------------------------------------------------------

  # <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
  # >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  home.stateVersion = "25.05"; # DO NOT EDIT! NOT EVEN WHEN UPDATING!

  # xdg.enable = true;

  #---------------------------------------------------------------------
  # Env vars and dotfiles
  #---------------------------------------------------------------------

  # home.sessionVariables = {
  # -- These are set in the shell config files:
  # LANG = "en_US.UTF-8";
  # LC_CTYPE = "en_US.UTF-8";
  # LC_ALL = "en_US.UTF-8";
  # EDITOR = "nvim";
  # PAGER = "less -FirSwX";
  # MANPAGER = "/bin/manpager";

  # -- These are worth taking a look:
  # AMP_API_KEY = "op://Private/Amp_API/credential";
  # OPENAI_API_KEY = "op://Private/OpenAPI_Personal/credential";
  # };

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # home.file = {
  #   ".gdbinit".source = ./gdbinit;
  #   ".inputrc".source = ./inputrc;
  # };

  # xdg.configFile = {
  #   "i3/config".text = builtins.readFile ./i3;
  #   "rofi/config.rasi".text = builtins.readFile ./rofi;
  #   "ghostty/config".text = builtins.readFile ./ghostty.linux;
  # }

  #---------------------------------------------------------------------
  # Programs
  #---------------------------------------------------------------------

  programs.git = {
    enable = true;
    userName = "Alejandro Banderas";
    userEmail = "alejandro.banderas@me.com";
    # signing = {
    #   key = "523D5DC389D273BC";
    #   signByDefault = true;
    # };
    # aliases = {
    #   cleanup = "!git branch --merged | grep  -v '\\*\\|master\\|develop' | xargs -n 1 -r git branch -d";
    #   prettylog = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(r) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
    #   root = "rev-parse --show-toplevel";
    # };
    extraConfig = {
      # branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      # credential.helper = "store"; # want to make this more secure
      github.user = "mabq";
      # push.default = "tracking";
      init.defaultBranch = "main";
    };
  };

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

  # programs.go = {
  #   enable = true;
  #   goPath = "code/go";
  #   goPrivate = [ "github.com/mitchellh" "github.com/hashicorp" "rfc822.mx" ];
  # };

  # programs.jujutsu = {
  #   enable = true;
  #
  #   # I don't use "settings" because the path is wrong on macOS at
  #   # the time of writing this.
  # };

  # programs.alacritty = {
  #   enable = true;
  #
  #   settings = {
  #     env.TERM = "xterm-256color";
  #
  #     key_bindings = [
  #       { key = "K"; mods = "Command"; chars = "ClearHistory"; }
  #       { key = "V"; mods = "Command"; action = "Paste"; }
  #       { key = "C"; mods = "Command"; action = "Copy"; }
  #       { key = "Key0"; mods = "Command"; action = "ResetFontSize"; }
  #       { key = "Equals"; mods = "Command"; action = "IncreaseFontSize"; }
  #       { key = "Subtract"; mods = "Command"; action = "DecreaseFontSize"; }
  #     ];
  #   };
  # };

  # programs.nushell = {
  #   enable = true;
  # };

  # programs.oh-my-posh = {
  #   enable = true;
  # };

  # services.gpg-agent = {
  #   enable = isLinux;
  #   pinentry.package = pkgs.pinentry-tty;
  #
  #   # cache the keys forever so we don't get asked for a password
  #   defaultCacheTtl = 31536000;
  #   maxCacheTtl = 31536000;
  # };

  # xresources.extraConfig = builtins.readFile ./Xresources;

  # Make cursor not tiny on HiDPI screens
  # home.pointerCursor = lib.mkIf (isLinux && !isWSL) {
  #   name = "Vanilla-DMZ";
  #   package = pkgs.vanilla-dmz;
  #   size = 128;
  #   x11.enable = true;
  # };
}
