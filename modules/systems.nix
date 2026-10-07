{
  systems = [
    # Required by `perSystem` configurations (packages, devShells, formatter,
    # checks, and so on). You can omit it if your flake only defines
    # `nixosConfigurations`.
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
  ];
}
