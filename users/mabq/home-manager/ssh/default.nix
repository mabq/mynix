# -- In the age module.
#    The script there is in change of decrypting the private ssh key.
# -- In the zsh module.
#    The SSH_AUTH_SOCK variable is exported for the ssh-agent to work.
{
  config,
  pkgs,
  repo,
  ...
}: let
  _outOfStore = config.lib.file.mkOutOfStoreSymlink;
  _config = "${repo}/modules/ssh/config";
in {
  # -- Install packages
  home.packages = [
    pkgs.openssh
  ];

  # -- Configure ssh the nix way
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  # -- Enable ssh-agent
  #    It holds your decrypted private keys in memory, so you only need to
  #    enter the passphrase once.
  #    The agent is provided as a systemd USER service.
  #    The zsh module exports the `SSH_AUTH_SOCK` env variable so that
  #    applications know how to talk to the agent.
  services.ssh-agent.enable = true;

  # -- Config files
  #    Do NOT link the entire directory!, you don't want any new keys to be
  #    included in the public repo.
  #    Do NOT change the name of the ssh key, otherwise also update the script
  #    in the age module.
  home.file.".ssh/id_ed25519.age".source = _outOfStore "${_config}/id_ed25519.age";
  home.file.".ssh/id_ed25519.pub".source = _outOfStore "${_config}/id_ed25519.pub";
}
