# Important:
#   Do not use inline comments in the config files!.
#
# From the man page:
#   (This does not apply to Nix, where we use Nix to concatenate file contents).
#   Included files should not contain an `[ids]` section.
#   Included files should not include other files (inclusion is non-recursive).
#   Included files should not end in `.conf`.
# 
# Useful commands:
#   Use `sudo keyd monitor` to show keyboards ids and keystrokes.
#   Use `sudo systemd enable/start keyd.service` to enable/start the service.
#   Use `sudo keyd reload` to update changes on config files.
#   Use `sudo journalctl -eu keyd` to check for errors.

{ config, pkgs, ... }:

let
  # Load keyd text configuration files:
  common = builtins.readFile ./config/common.conf;
  default = builtins.readFile ./config/default.conf;
  swapmods = builtins.readFile ./config/swapmods.conf;
in {
  environment.systemPackages = with pkgs; [
    # the `keyd` package is required to run `sudo keyd monitor`
    keyd
  ];

  services.keyd = {
    enable = true;
  };

  # -- Write config files to `/etc`:
  environment.etc = {
    # Concatenate files to create "default.conf"
    "keyd/default.conf".text = default + "\n" + common;

    # Contatenate files to create "swapmods.conf"
    "keyd/swapmods.conf".text = swapmods + "\n" + common;

    # Optional, but makes sure that when you type the make palm rejection work with keyd. See "https://github.com/rvaiya/keyd/issues/723"
    "libinput/local-overrides.quirks".text = ''
      [Serial Keyboards]
      MatchUdevType=keyboard
      MatchName=keyd virtual keyboard
      AttrKeyboardIntegration=internal
    '';
  };
}
