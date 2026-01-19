{ config, lib, ... }:
{
  imports = [
    ../helm/helm.nix
  ];

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

  services.k3s.enable = lib.mkIf config.server.enable true;
  services.k3s.role = lib.mkIf config.server.enable "server";
  # services.k3s.tokenFile = lib.mkIf config.server.enable config.sops.secrets.k3s-token.path;
  services.k3s.images = lib.mkIf config.server.enable [ config.services.k3s.package.airgap-images ];
  services.k3s.extraFlags = lib.mkIf config.server.enable [
    "--embedded-registry"
    "--disable metrics-server"
  ]; 
}
