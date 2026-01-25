{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      lunarvim
      nodejs
      python3
      ripgrep
      fd
  ];

  environment.variables = {
     EDITOR = "lvim";
  };


  # Optional: ensure config dir exists
  system.activationScripts.ensureLvimDir.text = ''
    mkdir -p /home/nickm/.config/lvim
  '';
}
