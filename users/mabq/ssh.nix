{
  outlink,
  configPath,
  ...
}: {
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  services.ssh-agent.enable = true;

  home.file = {
    # ".ssh/config".source = outlink "${configPath}/ssh/config"; # - DO NOT LINK THE WHOLE DIRECTORY!
    ".ssh/id_ed25519.age".source = outlink "${configPath}/ssh/id_ed25519.age"; # - DO NOT LINK THE WHOLE DIRECTORY!
    ".ssh/id_ed25519.pub".source = outlink "${configPath}/ssh/id_ed25519.pub"; # - DO NOT LINK THE WHOLE DIRECTORY!
  };
}
