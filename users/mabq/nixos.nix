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
    # - zsh
    #   Setting the default shell must be done in a NixOS module, so we cannot
    #   make this part of the zsh home-manager module.
    shell = pkgs.zsh;
    # - openssh
    #   The openssh service is configured in the host module.
    #   Here we only add the user's public ssh key as an authorized key.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5nMLQAi4YVaKO1vQoszgy03XlgbmMAuN3wzlFHain8 alejandro.banderas@me.com"
    ];
  };

  # --- programs ---

  programs.zsh = {
    # - zsh
    #   Nix complains if we do not enable the default shell.
    enable = true;
    #   For some reason these do not work when placed in the home-manager
    #   module.
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
}
