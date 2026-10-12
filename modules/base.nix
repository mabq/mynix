{
  inputs,
  lib,
  config,
  ...
}:
let
  inherit (config.mynix)
    host
    isUEFI
    stateVersion
    user
    timeZone
    ;
in
{
  options = {

    mynix.host = lib.mkOption {
      type = lib.types.str;
      description = "Machine name";
    };

    mynix.timeZone = lib.mkOption {
      type = lib.types.enum [
        "America/Guayaquil"
      ];
      default = "America/Guayaquil";
      description = "Machine time zone";
    };

    mynix.isUEFI = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Host has UEFI firmware (set to false if BIOS)";
    };

    mynix.stateVersion = lib.mkOption {
      type = lib.types.enum [
        "26.05"
        "26.11"
      ];
      description = "NixOS installer version";
    };

    mynix.user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user's name";
    };

    mynix.email = lib.mkOption {
      type = lib.types.str;
      description = "User's email (required for GitHub)";
    };

    mynix.theme = lib.mkOption {
      type = lib.types.enum [
        "catppuccin"
        "catppuccin-latte"
        "everforest"
        "gruvbox"
        "kanagawa"
        "nord"
        "rosepine"
        "tokyonight"
        "tokyonight-moon"
      ];
      default = "tokyonight-moon";
      description = "System theme";
    };

  };

  config = {

    systems = [
      # Required by `perSystem` configurations (packages, devShells, formatter,
      # checks, and so on). You can omit it if your flake only defines
      # `nixosConfigurations`.
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];

    flake.nixosModules.base = { pkgs, lib, ... }: {

      imports = [
        inputs.hjem.nixosModules.default
      ];

      boot = {
        loader = {
          # UEFI (systemd-boot)
          systemd-boot.enable = isUEFI;
          efi.canTouchEfiVariables = isUEFI;

          # BIOS (Grub)
          grub = {
            enable = !isUEFI;
            # device = # (set by disko)
            efiSupport = !isUEFI;
            efiInstallAsRemovable = !isUEFI;
          };
        };

        kernelPackages = lib.mkDefault pkgs.linuxPackages_latest; # latest version of the Linux kernel
      };

      environment = {
        systemPackages = with pkgs; [
          # age # Modern encryption tool with small explicit keys
          gh # CLI GitHub tool (authenticate from the terminal)
          git # Distributed version control system
          just # Handy way to save and run project-specific commands
          lazygit # Simple terminal UI for git commands
          neovim # Vim text editor fork
          yazi # Blazing fast terminal file manager written in Rust, based on async I/O
        ];

        # Add ~/.local/bin to PATH.
        #  This is where we put symlinks to binaries in this repo.
        localBinInPath = lib.mkDefault true;

        # Environment variables
        #  Pushed by NixOS to all shells (Bash, Zsh) and systemd user environment.
        #  Only include here variables you want always available. Read more in
        #  "environment-variables" learning notes.
        #  Important! Don't use `mkDefault` here
        sessionVariables = {
          # These help avoid hard-coding paths in configuration files (not all config
          # files accept environment variables).
          # MYNIX_REPO = "${repoDir}";
          # MYNIX_THEME = "${localThemeDirAbs}";

          # Include binaries of this repo in PATH
          # PATH = "${repoDir}/bin"; # don't use `<path>:$PATH` syntax here

          PAGER = "less -R --use-color -Dd+r -Du+b";
          MANPAGER = "less -R --use-color -Dd+r -Du+b";
          MANROFFOPT = "-P -c"; # https://wiki.archlinux.org/title/Color_output_in_console#Using_less
          # TERM = # do not set this variable, it is set by each terminal emulator.
        };
      };

      hjem = {
        clobberByDefault = true;
        users.${user}.directory = "/home/${user}";
      };

      i18n.defaultLocale = lib.mkDefault "en_US.UTF-8";

      networking = {
        hostName = lib.mkDefault host; # override it in host file if required
        firewall.enable = lib.mkDefault true; # tailscale can go through
      };

      nix = {
        package = lib.mkDefault pkgs.nixVersions.latest; # latest version of the cli

        settings = {
          # Enable flakes
          experimental-features = [
            "nix-command"
            "flakes"
          ];

          # Optimize storage
          #  https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
          auto-optimise-store = lib.mkDefault true;
        };

        # Register the flake input in the system registry (for commands like `nix run nixpkgs#...`).
        registry.nixpkgs.flake = inputs.nixpkgs;

        gc = {
          # Save disk space by doing garbage collection automatically
          #  https://nixos.org/manual/nixos/stable/#sec-nix-gc
          automatic = lib.mkDefault true;
          dates = lib.mkDefault "weekly";
          options = lib.mkDefault "--delete-older-than 15d";
        };
      };

      nixpkgs = {
        # https://nixos.org/manual/nixpkgs/unstable/#sec-config-options-reference
        config.allowUnfree = lib.mkDefault true;
      };

      security.sudo.wheelNeedsPassword = lib.mkDefault false; # no password for sudo (wheel members)

      services.tzupdate.enable = lib.mkDefault true; # update timezone automatically

      system.stateVersion = stateVersion;

      time.timeZone = lib.mkDefault timeZone;

      users = {
        mutableUsers = lib.mkDefault false; # do not allow imperative changes
        users.${user} = {
          isNormalUser = lib.mkDefault true;
          home = lib.mkDefault "/home/${user}";
          # packages = with pkgs; [ ];
        };
      };

    };
  };
}
