{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.helm;
in
{
  options.services.helm = {
    enable = mkEnableOption "Helm with common plugins";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.wrapHelm pkgs.kubernetes-helm {
        plugins = with pkgs.kubernetes-helmPlugins; [
          helm-diff
          helm-secrets
          helm-s3
        ];
      })
    ];
  };
}

