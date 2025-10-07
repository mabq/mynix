{user, ...}: {

  # ----------------------------------------------------------------------------

  imports = [
    # -- The keyd module expect a layout name first, then it returns a module
    (import ../../../modules/keyd "layout-f")
  ];

  # ----------------------------------------------------------------------------

  # -- User account

  users.users.${user} = {
    isNormalUser = true;
    home = "/home/${user}";
    extraGroups = ["wheel"];
    # -- Use `mkpasswd -m sha-512` to hash a password
    hashedPassword = "$6$P.O5dcCJEOVAdAZP$ep65kPcAQEj3W6nrEN7tg9NRbf4R2BdLZ3Oy5VZUIG/ANE3PQnGzmCBFnos6HjpXwWWlf1i54FUl.XAFL4qLm1";
  };

  # ----------------------------------------------------------------------------

  # -- ZSH

  #    Set zsh as default login shell (home-manager only affects interactive shells)
  users.users.${user}.shell = pkgs.zsh;

  #    Must enable the default shell, otherwise nix complains
  programs.zsh.enable = true;

  #    These should be in the home-manager module but for some reason they
  #    don't work when placed there.
  programs.zsh.autosuggestions.enable = true;
  programs.zsh.syntaxHighlighting.enable = true;

  # ----------------------------------------------------------------------------

  # -- OpenSSH

  #    The service is enabled by defatul in the "machines" section, here we
  #    only add my public SSH key as an authorized key to be able to login
  #    without entering a password.
  users.users.${user}.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5nMLQAi4YVaKO1vQoszgy03XlgbmMAuN3wzlFHain8 alejandro.banderas@me.com"
  ];

}
