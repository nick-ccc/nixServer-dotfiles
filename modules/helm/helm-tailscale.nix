{ config, lib, ... }:

let
  cfg = config.services.tailscaleHelm;
  #tailscaleValues = builtins.fromJSON (builtins.readFile (pkgs.runCommand "decrypt-tailscale" {} ''
  #  sops -d /etc/tailscale/values.sops.yaml > $out
  #''));
  jsonFile = ./tailscale-oauth.json;
  jsonContent = builtins.readFile jsonFile;
  tailscaleValues = builtins.fromJSON jsonContent;
in
{
  options.services.tailscaleHelm = {
    enable = lib.mkEnableOption "Tailscale installed via Helm";

    namespace = lib.mkOption {
      type = lib.types.str;
      default = "tailscale";
      description = "Kubernetes namespace for Tailscale";
    };

    valuesFile = lib.mkOption {
      type = lib.types.path;
      default = "/etc/tailscale/values.yaml";
      description = "Path to Helm values.yaml for Tailscale";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = config.services.helm.enable;
        message = "services.tailscaleHelm requires services.helm.enable = true";
      }
    ];

    # Deploy helm chart for tailscale
    services.k3s.autoDeployCharts.tailscale-operator = {
      name = "tailscale-operator";
      repo = "https://pkgs.tailscale.com/helmcharts";
      hash = "sha256-nV0Ql9Z+Fcf7oH5SwmcNieIVBIoD37N+jNhGnzp+K8A=";
      version = "1.92.5";
      createNamespace = true;
      values = {
        oauth = {
          clientId = tailscaleValues.clientId;
          clientSecret = tailscaleValues.audience;
        };
      };   
    };
  };
 }
