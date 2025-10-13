{
  pkgs,
  user,
  ...
}: {
  imports = [
    # - keyd module expects a configuration name first
    (import ../../modules/keyd "v1")
  ];

  # --- users ---

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    # - No password for sudo actions, see machine config.
    extraGroups = ["wheel"];
    # - Produce a password hash with `mkpasswd -m sha-512`.
    hashedPassword = "$6$P.O5dcCJEOVAdAZP$ep65kPcAQEj3W6nrEN7tg9NRbf4R2BdLZ3Oy5VZUIG/ANE3PQnGzmCBFnos6HjpXwWWlf1i54FUl.XAFL4qLm1";
    # - In NixoS, the default shell must be set in a NixOS module, see the
    #   zsh home-manager module for more information.
    shell = pkgs.zsh;
    # - The openssh service is configured in the host module. Here we only add
    #   the user's public ssh key as an authorized key.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5nMLQAi4YVaKO1vQoszgy03XlgbmMAuN3wzlFHain8 alejandro.banderas@me.com"
    ];
  };

  # --- programs ---

  programs.zsh = {
    # - Nix complains if we do not enable the default shell.
    enable = true;
    # - Since this NixOS module owns the zsh configuration these must also be
    #   placed here (not in the Home-manager module).
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
}
