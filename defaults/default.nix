# Use `mkDefault`, these should be overidable.
{
  config,
  lib,
  pkgs,
  host,
  user,
  repoBranch,
  repoName,
  repoUrl,
  repoDir,
  repoThemeDirAbs,
  localThemeDir,
  localThemeDirAbs,
  ...
}:
with lib;
{
  # ----------------------------------------------------------------------------
  # NixOS
  # ----------------------------------------------------------------------------

  # Clone the repo automatically on first boot.
  #  Most config files are symlinks pointing to this repository, so we need the
  #  repository in place since the very first boot.
  systemd.services."clone-${repoName}" = {
    description = "Clone ${repoName} repository if missing";
    wantedBy = [ "multi-user.target" ];
    before = [ "home-manager-${user}.service" ];
    unitConfig.ConditionPathExists = "!${repoDir}/.git";
    serviceConfig = {
      Type = "oneshot";
      User = config.users.users.${user}.name;
      ExecStart = [
        # systemd requires absolute paths to executables
        "${pkgs.git}/bin/git clone ${repoUrl} ${repoDir}"
        "${pkgs.git}/bin/git -C ${repoDir} checkout ${repoBranch}"
      ];
    };
  };

  # -- Nix ---------------------------------------------------------------------

  nix = {
    # Use the latest version of the cli
    package = mkDefault pkgs.nixVersions.latest;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      # Optimize storage
      #  https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
      auto-optimise-store = mkDefault true;
    };
    gc = {
      # Save disk space by doing garbage collection automatically
      #  https://nixos.org/manual/nixos/stable/#sec-nix-gc
      automatic = mkDefault true;
      dates = mkDefault "weekly";
      options = mkDefault "--delete-older-than 15d";
    };
  };

  nixpkgs = {
    # https://nixos.org/manual/nixpkgs/unstable/#sec-config-options-reference
    config.allowUnfree = mkDefault true;
  };

  # -- Linux -------------------------------------------------------------------

  boot = {
    # Use the absolute newest, bleeding-edge Linux kernel version available in
    # the nixpkgs repository
    kernelPackages = mkDefault pkgs.linuxPackages_latest;
  };

  # -- Network -----------------------------------------------------------------

  networking = {
    hostName = mkDefault host; # override it in host file if required
    firewall.enable = mkDefault true; # tailscale can go through
  };

  # -- Time and locale ---------------------------------------------------------

  time.timeZone = mkDefault "America/Guayaquil";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";
  services.tzupdate.enable = mkDefault true; # update timezone automatically

  # -- User accounts -----------------------------------------------------------

  users = {
    mutableUsers = mkDefault false; # no imperative changes
    users.${user} = {
      isNormalUser = mkDefault true;
      home = mkDefault "/home/${user}";
    };
  };

  # No password when escalating privileges for members of the `wheel` group
  security.sudo.wheelNeedsPassword = mkDefault false;

  # -- Environment -------------------------------------------------------------

  environment = {
    # systemPackages = with pkgs; [ ];

    # Add ~/.local/bin to PATH.
    #  This is where we put symlinks to binaries in this repo.
    localBinInPath = mkDefault true;

    # Environment variables
    #  Pushed by NixOS to all shells (Bash, Zsh) and systemd user environment.
    #  Only include here variables you want always available. Read more in
    #  "environment-variables" learning notes.
    #  Important! Don't use `mkDefault` here
    sessionVariables = {
      # These help avoid hard-coding paths in configuration files (not all config
      # files accept environment variables).
      MYNIX_REPO = "${repoDir}";
      MYNIX_THEME = "${localThemeDirAbs}";

      # Include binaries of this repo in PATH
      # PATH = "${repoDir}/bin"; # don't use `<path>:$PATH` syntax here

      PAGER = "less -R --use-color -Dd+r -Du+b";
      MANPAGER = "less -R --use-color -Dd+r -Du+b";
      MANROFFOPT = "-P -c"; # https://wiki.archlinux.org/title/Color_output_in_console#Using_less
      # TERM = # do not set this variable, it is set by each terminal emulator.
    };
  };

  # -- Services ----------------------------------------------------------------

  services = {
    openssh = {
      # The private key file is created by `/secrets/sops.nix` if you pass it
      # as a secret for the selected system configuration.
      enable = mkDefault true;
      settings = {
        PermitRootLogin = mkDefault "no"; # Never!
        PasswordAuthentication = mkDefault false; # No! Use tailscale or ssh keys.
      };
    };

    tailscale =
      let
        # You can provide the tailscale auth key as a secret to login
        # automatically. Otherwise, login manually with `sudo tailscale login`.
        hasAuthKey = config ? sops.secrets.tailscaleAuthKey;
      in
      {
        enable = mkDefault true;
        authKeyFile = lib.mkIf hasAuthKey config.sops.secrets.tailscaleAuthKey.path;
        extraUpFlags = [
          # See possible flags in https://tailscale.com/docs/reference/tailscale-cli#set
          "--hostname=${config.networking.hostName}"
          "--ssh" # Make sure you have a proper access policy in place.
        ];
      };
  };

  # ----------------------------------------------------------------------------
  # Home-manager
  # ----------------------------------------------------------------------------

  home-manager = {
    # Make HomeManager use the global `pkgs` that is configured via the system
    # level nixpkgs options. This saves an extra Nixpkgs evaluation, adds
    # consistency, and removes the dependency on `NIX_PATH`, which is otherwise
    # used for importing Nixpkgs.
    useGlobalPkgs = mkDefault true;

    # Install packages in `/etc/profiles` instead of `~/.nix-profile`.
    # This makes garbage collection work for both Nixos and HomeManager.
    useUserPackages = mkDefault true;

    # Use the home-manager module of sops-nix for correct permissions
    sharedModules = [ sops-nix.homeManagerModules.sops ];

    users.${user} =
      {
        osConfig, # https://nix-community.github.io/home-manager/installation/nixos.html#sec-install-nixos-module
        config,
        ...
      }:
      let
        mkOutOfStoreSymlink = config.lib.file.mkOutOfStoreSymlink;
      in
      {
        home = {
          username = user;
          # NixOS' option `users.users.<name>.home` (set above) is the source
          # of truth for the OS. This option is just a path home-manager writes
          # files into.
          homeDirectory = "/home/${user}";
          stateVersion = osConfig.system.stateVersion;
          packages = with pkgs; [
            # -- Packages always required --
            just # Handy way to save and run project-specific commands
            age # Modern encryption tool with small explicit keys
            yazi # Blazing fast terminal file manager written in Rust, based on async I/O
            neovim # Vim text editor fork
            gh # CLI GitHub tool (authenticate from the terminal)
            git # Distributed version control system
            lazygit # Simple terminal UI for git commands
          ];

          # Symlink the selected theme
          file."${localThemeDir}" = {
            source = mkOutOfStoreSymlink "${repoThemeDirAbs}";
            force = true;
          };
        };
      };
  };
}
