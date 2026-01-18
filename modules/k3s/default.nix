{ config, lib, pkgs, ... }:

with lib;

{ 
  options.server.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable server role for K3s";
  };

  options.agent.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Enable agent role for K3s";
  };

  # Import both server and agent modules unconditionally
  imports = [
    ./server.nix
    ./agent.nix
  ];
}
