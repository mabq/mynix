layout:
{pkgs, ...}: {
  services.keyd.enable = true;

  environment.systemPackages = [
    # -- Required to run `sudo keyd monitor`
    pkgs.keyd
  ];

  # -- Config files
  #    Link the whole directory.
  #    Keyd only accepts config files in `/etc/keyd`, so this one cannot be out-of-store.
  #    If you need to try out new things see https://wiki.nixos.org/wiki/Keyd to avoid re-building on every change.
  environment.etc."keyd".source = "./config/${layout}";
  #    Optional, but makes sure that when you type the make palm rejection
  #    work with keyd.
  #    See https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
