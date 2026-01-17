{ config, ... }:
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

  services.k3s = {
    enable = true;
    role = "agent";
    tokenFile = config.sops.secrets.k3s-token.path;
    serverAddr = "https://SERVER-NODE-IP:6443";
  };
}