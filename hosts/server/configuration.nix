{ config, lib, pkgs, ... }:

{
  config = {

    # Used in K3s installation decision
    server.enable = true;
    services.helm.enable = true;

    # Users
    users.groups.k3sconfig = {};
    users.users = {
      nickm = {
          isNormalUser = true;
          description = "Nick";
          extraGroups = [ "wheel" "networkmanager" "k3sconfig" ];
        };
      };
    # For admin privileges
    users.groups.wheel.members = [ "nickm" ];

    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Packages
    environment.systemPackages = with pkgs; [ 
      git
      openssl
      sops
      btop
    ];

    # Allows for rootless access
    environment.variables = {
      KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
    };

    # Journal
    services.journald.extraConfig = "SystemMaxUse=50M\nSystemMaxFiles=5";
    services.journald.rateLimitBurst = 500;
    services.journald.rateLimitInterval = "30s";

    # Locale and TZ
    time.timeZone = "America/New_York";
    services.timesyncd.enable = true;
    i18n.defaultLocale = "en_US.UTF-8";
    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
    };

    # Fix nix path
    nix.nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos"
                    "nixos-config=$HOME/dotfiles/nodes/server/configuration.nix"
                    "/nix/var/nix/profiles/per-user/root/channels"
                  ];

    # Ensure nix flakes are enabled
    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    # Substituters
    nix.settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # wheel group gets trusted access to nix daemon
    nix.settings.trusted-users = [ "@wheel" ];

    # Silent Boot
    # https://wiki.archlinux.org/title/Silent_boot
    boot.kernelParams = [
      "quiet"
      "splash"
      "vga=current"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
    boot.initrd.systemd.enable = true;
    boot.initrd.verbose = false;
    boot.plymouth.enable = true;

    # Networking
    networking.networkmanager.enable = true;
    networking.hostName = "server";

    # Remove bloat
    programs.nano.enable = lib.mkForce false;

    # Enable SSH
    services.openssh.enable = true;

    # Configure keymap in X11
    services.xserver.xkb = {
      layout = "us";
      variant = "";
    };

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your k3s were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this k3s.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.11"; # Did you read the comment?
  };

}
