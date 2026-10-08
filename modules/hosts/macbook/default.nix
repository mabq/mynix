{
  self,
  inputs,
  config,
  ...
}:
{
  mynix = {
    host = "macbook";
    stateVersion = "26.05";
    user = "mabq";
    email = "alejandro.banderas@me.com";
  };

  flake.nixosConfigurations.${config.mynix.host} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.hjem.nixosModules.default
      inputs.sops-nix.nixosModules.sops
      self.nixosModules."hosts-${config.mynix.host}"
    ];
  };
}
