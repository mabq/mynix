{ self, inputs, ... }:
{
  flake.nixosConfigurations."macbook" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      {
        mynix = {
          host = "macbook";
          stateVersion = "26.05";
        };
      }
      self.nixosModules."hosts-macbook"
    ];
  };
}
