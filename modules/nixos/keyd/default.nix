_config: {pkgs, ...}: {
  services.keyd.enable = true;

  # - The service is enough to use keyd but if you want to debug things up
  #   with `sudo keyd monitor` you must also install the `keyd` package.
  environment.systemPackages = [
    pkgs.keyd
  ];

  # - Link config directory
  #   Keyd only accepts config files in `/etc/keyd`, so this one cannot be
  #   out-of-store.
  #   If you need to try out new things just replace those links with temp
  #   files, once keyd is working as expected replace files in this repository
  #   with the new files, then delete those files from `/etc/keyd` and then
  #   rebuild the system.
  #   For more information see https://wiki.nixos.org/wiki/Keyd.
  environment.etc."keyd".source = ./configs/${_config};

  # - Optional, but makes sure that when you type the make palm rejection
  #   work with keyd.
  #   See https://github.com/rvaiya/keyd/issues/723
  # environment.etc."libinput/local-overrides.quirks".text = ''
  #   [Serial Keyboards]
  #   MatchUdevType=keyboard
  #   MatchName=keyd virtual keyboard
  #   AttrKeyboardIntegration=internal
  # '';
}
