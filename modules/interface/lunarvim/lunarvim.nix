{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    lunarvim
    nodejs
    python3
    ripgrep
    fd
  ];

  home.sessionVariables = {
    EDITOR = "lvim";
  };

  # Optional: ensure config dir exists
  home.activation.ensureLvimDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p "$HOME/.config/lvim"
  '';
}