# THIS IS A NIXOS MODULE, DO NOT IMPORT IT FROM HOME-MANEGER!
# IT GOES HERE SO THAT YOU CAN IMPORT PER MACHINE BASIS.
{pkgs, ...}: {
  services.keyd.enable = true;

  environment.systemPackages = [
    pkgs.keyd # required to run `sudo keyd monitor`
  ];

  # Link the whole directory.
  # Keyd only accepts config files in `/etc/keyd`.
  # This one cannot be out-of-store, so if you need to try out new things
  # see https://wiki.nixos.org/wiki/Keyd.
  environment.etc."keyd".source = ./config;

  # Optional, but makes sure that when you type the make palm rejection
  # work with keyd -- https://github.com/rvaiya/keyd/issues/723
  environment.etc."libinput/local-overrides.quirks".text = ''
    [Serial Keyboards]
    MatchUdevType=keyboard
    MatchName=keyd virtual keyboard
    AttrKeyboardIntegration=internal
  '';
}
