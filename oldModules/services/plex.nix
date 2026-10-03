{
  lib,
  config,
  # user,
  ...
}:
let
  cfg = config.mynix.services.plex;
in
{
  config = lib.mkIf cfg.enable {
    services.plex = {
      # Configure Plex via `http://<SERVER-IP>:32400/web`
      enable = true;
      openFirewall = true;
      # user = user; # should not run as my user, it could read secret files only readble by me
    };
  };
}
