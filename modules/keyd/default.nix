layout:
{
  pkgs,
  ...
}: {
  services.keyd.enable = true;

  environment.systemPackages = [
    # -- Required to run `sudo keyd monitor`
    pkgs.keyd
  ];

  # Link the whole config directory. Keyd only accepts config files in
  # `/etc/keyd`, so this one cannot be out-of-store. If you need to try out new
  # things see the following link to avoid re-building on every change.
  # https://wiki.nixos.org/wiki/Keyd
  environment.etc."keyd".source = ./config/${layout};

  # Optional, but makes sure that when you type the make palm rejection
  # work with keyd.
  # https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
