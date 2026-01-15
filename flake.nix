{
  description = "Flake for homelab single node K3S";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };
  outputs = {self, nixpkgs, nixpkgs-unstable, ...}:  
    let 
        lib = nixpkgs.lib;
    in {
      nixosConfigurations = {
        nixosK3S-n = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
        };
    };
  };
}
