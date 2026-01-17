{
  description = "Flake for homelab single node K3S, with expansion for future nodes";


  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      sops-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      hosts = builtins.filter (x: x != null) (
        lib.mapAttrsToList (name: value: if (value == "directory") then name else null) (
          builtins.readDir ./hosts
        )
      );
    in {
      # generate a nixos configuration for every host in ./hosts
      nixosConfigurations = builtins.listToAttrs (
        map (host: {
          name = host;
          value = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              # host specific config
              config {
                networking.hostName = host;
              }
              ./hosts/${host}/configuration.nix
#              (inputs.secrets.hostSecrets.${host})

              ./modules/k3s/default.nix
              ./modules/user/default.nix
              ./modules/interface/default.nix
            ];
            specialArgs = {
              inherit inputs;
            };
          };
        }) hosts
      );
    };
}
