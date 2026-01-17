{ config, lib, ... }:
{
  imports = [];

#  sops = {
#    defaultSopsFile = ./secrets.yaml;
#    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
#    secrets.k3s-token = { };
#  };

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
      # Node exporter
      9100
    ];
    # Flannel VXLAN
    allowedUDPPorts = [ 8472 ];
  };

  services.k3s.enable = lib.mkIf config.agent.enable true;
  services.k3s.role = lib.mkIf config.agent.enable "agent";
  services.k3s.tokenFile = lib.mkIf config.agent.enable config.sops.secrets.k3s-token.path;
  services.k3s.serverAddr = lib.mkIf config.agent.enable "https://SERVER-NODE-IP:6443";
}
