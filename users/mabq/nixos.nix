{pkgs, ...}: {
  # environment.localBinInPath = true; # -- Add ~/.local/bin to PATH

  users.users.mabq = {
    isNormalUser = true;
    home = "/home/mabq";
    # extraGroups = [ "docker" "lxd" "wheel" ];
    extraGroups = ["wheel"];
    shell = pkgs.bash;
    hashedPassword = "$6$P.O5dcCJEOVAdAZP$ep65kPcAQEj3W6nrEN7tg9NRbf4R2BdLZ3Oy5VZUIG/ANE3PQnGzmCBFnos6HjpXwWWlf1i54FUl.XAFL4qLm1"; # use `mkpasswd -m sha-512`
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5nMLQAi4YVaKO1vQoszgy03XlgbmMAuN3wzlFHain8 alejandro.banderas@me.com"
    ];
  };
}
