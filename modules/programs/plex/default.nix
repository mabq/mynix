{
  flake.nixosModules.plex = {
    services.plex = {
      enable = true;
      openFirewall = true;
      # user = user; # should not run as my user, it could read secret files only readble by me
    };
  };
}

# Configure Plex via `http://<SERVER-IP>:32400/web`
