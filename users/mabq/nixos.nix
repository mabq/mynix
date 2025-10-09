{user, pkgs, ...}: {

  imports = [
    # This module expects the layout name on the first call.
    (import ../../modules/keyd "layout-f")
    # ../../modules/keyd
  ];

  # ----------------------------------------------------------------------------
  # User account
  # ----------------------------------------------------------------------------

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    # No password for sudo actions, see machine config.
    extraGroups = ["wheel"];
    # Produce a password hash with `mkpasswd -m sha-512`.
    hashedPassword = "$6$P.O5dcCJEOVAdAZP$ep65kPcAQEj3W6nrEN7tg9NRbf4R2BdLZ3Oy5VZUIG/ANE3PQnGzmCBFnos6HjpXwWWlf1i54FUl.XAFL4qLm1";
    # zsh: Set as default shell
    shell = pkgs.zsh;
    # openssh: The service itself is configured in the machine module. Here we
    # only add the user's public key for passwordless remote login.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5nMLQAi4YVaKO1vQoszgy03XlgbmMAuN3wzlFHain8 alejandro.banderas@me.com"
    ];
  };

  programs.zsh = {
    # Enable default shell, otherwise nix complains.
    enable = true;
    # These plugins should be home-manager but for some reason they don't work
    # when placed there.
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
}
