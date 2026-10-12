{ self, inputs, ... }:
{
  flake.nixosConfigurations."macbook" = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.hjem.nixosModules.default
      self.nixosModules."hostConfig-macbook"
    ];
  };
}
