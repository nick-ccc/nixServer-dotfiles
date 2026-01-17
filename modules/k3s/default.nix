{ config, lib, pkgs, ... }:
{
  # Import both server and agent modules unconditionally
  imports = [
    ./server.nix
    ./agent.nix
  ];

  server.enable = lib.mkDefault true;
  agent.enable = lib.mkDefault true;
}
