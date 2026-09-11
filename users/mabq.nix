# Options inherent to this user only!
{ pkgs, user, ... }:
{
  users.users.${user} = {
    # NixOS groups all human accounts into the `users` group.
    # group = "${user}";

    # Elevated privileges without password
    extraGroups = [ "wheel" ];

    # User account password
    #  The defaults module disables imperative changes, so this is the only way
    #  to set the user account password. For improved security, the default
    #  module also disables using account credentials for ssh authentication.
    #  Use `mkpasswd -m sha-512` to create a passwork hash.
    hashedPassword = "$6$slFKhHBtWmrAa8NN$dZD4TelNDAISrLJHAM.35K31m/0MszqHJ.7kuLdNC444FwprmHxvgU3SAcIgIeDpCFhO2EfWbU43JPnSrLGA01";

    # Authorized ssh keys
    #  The public key should be included as an authorized key in all machines
    #  configured with this account. Yet, not all machines configured with this
    #  account should posses the private. You should be able to ssh into a
    #  server from your workstation, but not the other way around.
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINjOlPls0gNkjBTOvXIbmm7HbSUOHM+erfwE4tdNVMLn"
    ];
  };

  home-manager.users.${user} = {
    home.packages = with pkgs; [
      # -- CLI utils
      caligula # User-friendly, lightweight TUI for disk imaging
      exfatprogs # exFAT filesystem userspace utilities
      fastfetch # Actively maintained, feature-rich and performance oriented, neofetch like system information tool
      fzf # Command-line fuzzy finder
      pciutils # Collection of programs for inspecting and manipulating configuration of PCI devices
      psmisc # Set of small useful utilities that use the proc filesystem (such as fuser, killall and pstree)
      ripgrep # Utility that combines the usability of The Silver Searcher with the raw speed of grep
    ];
  };
}
