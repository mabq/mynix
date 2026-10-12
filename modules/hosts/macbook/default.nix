{
  self,
  inputs,
  config,
  ...
}:
{
  config = {

    mynix = {
      host = "macbook";
      stateVersion = "26.05";
      user = "mabq";
      email = "alejandro.banderas@me.com";
    };

    flake.nixosConfigurations.${config.mynix.host} = inputs.nixpkgs.lib.nixosSystem {
      modules = [
        self.nixosModules."hosts-${config.mynix.host}"
      ];
    };

  };
}
