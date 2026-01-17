{ config, ... }:
{
  imports = [];

  networking.firewall = {
    allowedTCPPorts = [
      # SSH
      22
      # HTTP
      80
      # HTTPS
      443
      # Embedded registry (spegel)
      5001
      # Kubernetes API server
      6443
      # Node exporter
      9100
    ];
    # Flannel VXLAN
    allowedUDPPorts = [ 8472 ];
  };

  services.k3s = {
    enable = true;
    role = "server";
    tokenFile = config.sops.secrets.k3s-token.path;
    images = [ config.services.k3s.package.airgap-images ];
    extraFlags = [
      "--embedded-registry"
      "--disable metrics-server"
    ];
  };
}