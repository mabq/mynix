{pkgs, ...}: {
  users.users.mabq = {
    isNormalUser = true;
    home = "/home/mabq";
    extraGroups = ["wheel"];
    # -- Default shell.
    #    The difference between setting the default shell in a NixOS module and
    #    a Home manager module is that the prior affects the login shell and
    #    the later only interactive shells.
    shell = pkgs.zsh;
    hashedPassword = "$6$P.O5dcCJEOVAdAZP$ep65kPcAQEj3W6nrEN7tg9NRbf4R2BdLZ3Oy5VZUIG/ANE3PQnGzmCBFnos6HjpXwWWlf1i54FUl.XAFL4qLm1"; # use `mkpasswd -m sha-512`
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5nMLQAi4YVaKO1vQoszgy03XlgbmMAuN3wzlFHain8 alejandro.banderas@me.com"
    ];
  };

  # -- Enable the default shell.
  #    Nix throws an error if the default shell is not enabled in a NixOS module.
  programs.zsh.enable = true;

  # -- Zsh plugins.
  #    These should be in the zsh module but for some reason they don't work
  #    when placed there.
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;

  # -- No password for sudo.
  #    Specifically for the given user, not all users of the wheel group.
  security.sudo.extraRules = [
    {
      users = ["mabq"];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
