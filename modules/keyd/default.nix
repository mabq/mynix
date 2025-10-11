configName: {pkgs, ...}: {
  # - Enable the service
  services.keyd.enable = true;

  # - The package is required to run `sudo keyd monitor`
  environment.systemPackages = [
    pkgs.keyd
  ];

  # - Link the whole config directory.
  #   Keyd only accepts config files in `/etc/keyd`, so this one cannot be
  #   out-of-store.
  #   If you need to try out new things just replace those links with new
  #   files, once keyd is working as expected place those files in this
  #   repository and rebuild to link them. See https://wiki.nixos.org/wiki/Keyd.
  environment.etc."keyd".source = ./config/${configName};

  # - Optional, but makes sure that when you type the make palm rejection
  #   work with keyd.
  #   See https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
