{
  self,
  inputs,
  config,
  ...
}:
{
  mynix.host = {
    name = "macbook";
    stateVersion = "26.05";
  };

  mynix.user = {
    name = "mabq";
    email = "alejandro.banderas@me.com";
  };

  flake.nixosConfigurations.${config.mynix.host.name} = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules."${config.mynix.host.name}-config"
    ];
  };
}
