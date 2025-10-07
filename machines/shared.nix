{
  lib,
  pkgs,
  machine,
  ...
}: {
  imports = [];

  # ----------------------------------------------------------------------------

  # -- Use the most recent stable kernel available in Nixpkgs
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

  # -- Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # -- VMware, Parallels
  #    Both only support this being 0 otherwise you see "error switching console
  #    mode" on boot.
  # boot.loader.systemd-boot.consoleMode = lib.mkDefault "0";

  # ----------------------------------------------------------------------------

  # -- Use the latest version of the CLI regardless of nixpkgs version
  nix.package = lib.mkDefault pkgs.nixVersions.latest;

  # -- Enable flakes and the new cli
  #    See https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled#enable-nix-flakes
  nix.settings.experimental-features = ["flakes" "nix-command"];

  # -- Public binary cache
  # nix.settings = {
  #   substituters = ["https://mitchellh-nixos-config.cachix.org"];
  #   trusted-public-keys = ["mitchellh-nixos-config.cachix.org-1:bjEbXJyLrL1HZZHBbO4QALnI5faYZppzkU4D2s0G8RQ="];
  # };

  # ----------------------------------------------------------------------------

  # -- Allow some packages considered insecure
  # nixpkgs.config.permittedInsecurePackages = [];

  # ----------------------------------------------------------------------------

  # -- Default hostname
  networking.hostName = lib.mkDefault machine;

  # -- The global useDHCP flag is deprecated, therefore explicitly set to false
  #    here. Per-interface useDHCP will be mandatory in the future, so this
  #    generated config replicates the default behaviour.
  # networking.useDHCP = lib.mkDefault false;

  # -- Enable the firewall
  networking.firewall.enable = lib.mkDefault true;

  # ----------------------------------------------------------------------------

  # -- Disable command that affect users or groups
  #    Don't forget to set a password with `passwd`
  users.mutableUsers = lib.mkDefault false;

  # ----------------------------------------------------------------------------

  # -- Don't require password for sudo (wheel members)
  security.sudo.wheelNeedsPassword = lib.mkDefault false;

  # ----------------------------------------------------------------------------

  i18n = {
    # -- Determines the language for program messages, the format for dates and
    #    times, sort order, and so on.
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    # -- Software to input symbols that are not available on standard input devices.
    # inputMethod = {
    #   enable = true;
    #   type = "fcitx5";
    #   fcitx5.addons = with pkgs; [
    #     fcitx5-chinese-addons
    #     fcitx5-gtk
    #     fcitx5-hangul
    #     fcitx5-mozc
    #   ];
    # };
  };

  # ----------------------------------------------------------------------------

  time.timeZone = lib.mkDefault "America/Guayaquil";

  # ----------------------------------------------------------------------------

  fonts = {
    fontDir.enable = true;
    packages = [
      pkgs.fira-code
      pkgs.jetbrains-mono
    ];
  };

  # ----------------------------------------------------------------------------

  # -- To search run `nix search <term>`
  environment.systemPackages = [
    pkgs.gnumake
  ];

  # ----------------------------------------------------------------------------

  # -- OpenSSH
  services.openssh.enable = lib.mkDefault true;
  services.openssh.settings.PasswordAuthentication = lib.mkDefault true;
  services.openssh.settings.PermitRootLogin = lib.mkDefault "no";

  # -- Tailscale
  #    Manually authenticate with `sudo tailscale up`
  # services.tailscale.enable = lib.mkDefault true;

  # -- Flatpak
  # services.flatpak.enable = lib.mkDefault true;

  # -- Snap
  # services.snap.enable = lib.mkDefault true;

  # ----------------------------------------------------------------------------

  # virtualisation.docker.enable = lib.mkDefault true;
  # virtualisation.lxd = {
  #   enable = lib.mkDefault true;
  # };

  # ----------------------------------------------------------------------------

  # -- This value determines the NixOS release from which the default
  #    settings for stateful data, like file locations and database versions
  #    on your system were taken. It‘s perfectly fine and recommended to leave
  #    this value at the release version of the first install of this system.
  #    Before changing this value read the documentation for this option
  #    (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # -- Did you read the comment?
}
