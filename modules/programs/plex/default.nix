{
  flake.nixosModules.plex = {
    services.plex = {
      enable = true;
      openFirewall = true;
      # user = user; # No!, see notes below.
    };
  };
}

/*
  Configure libraries
  -------------------

    To configure plex libraries visit `http://<ip>:32400/web`.

  Do not run plex as the primary user
  -----------------------------------

    Plex is a network-facing service. It runs a web server, parses untrusted
    media files and metadata, runs a transcoder, loads plugins, and usually has
    remote access enabled through plex.tv. If a vulnerability in any of that
    gets exploited, the attacker runs as whatever user Plex runs as.

    As the `plex` user: they get the Plex data directory and read access to
    your media, and little else.

    As your primary user: they get everything that user can touch: your home
    directory, SSH keys, browser profiles and saved sessions, password manager
    files, GPG keys, shell history, and anything you can write to. If you’re in
    `wheel`, that’s also a stepping stone toward root (for example, by planting a
    trojaned shell alias or binary in your `PATH` and waiting for you to run
    `sudo`).

    Plex has had real security issues over the years, so this is not purely
    theoretical.

  Permissions
  -----------

    Directories containing media files must be readable by the `plex` user/group.

    If the service fails to start, review logs with `sudo journalctl -u plex.service`.
*/
