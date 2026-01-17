{ config, pkgs, ... }: {
  programs.zsh = {
      enable = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
  };

  programs.bash = {
      enable = true;
      enableCompletion = true;
      shellAliases = config.programs.zsh.shellAliases;
  };

  programs.direnv.enable = true;
  programs.direnv.enableZshIntegration = true;
  programs.direnv.nix-direnv.enable = true;
  programs.direnv.nix-direnv.package = pkgs.nix-direnv;
}
