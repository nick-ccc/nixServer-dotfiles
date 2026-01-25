<h1 align="center">
    Homelab | NIX | K3s
</h1>

<p align="center">
  <a href="https://nixos.org/blog/announcements/2025/nixos-2511/">
    <img 
        src=".assets/nixos-25.11.webp"  
        alt="Gopher Doc" 
        width="200" 
    />
  </a>
</p>

***

# The Homelab

This repository contains the full configuration and operational definition of my personal homelab environment, 
built on NixOS and k3s. The goal of this homelab is to provide a reproducible, declarative, 
and production-inspired platform for running self-hosted services, learning kubernetes, and experimenting 
with NixOS.

### Nodes


<div align="center">

|   Name   | Role       |                                                       Hardware                                                       |          Notes           |
|:--------:|:----------:|:--------------------------------------------------------------------------------------------------------------------:|:------------------------:|
| `server` | k3s server | [GMK mini pc](https://www.gmktec.com/products/nucbox-g3-plus-enhanced-performance-mini-pc-with-intel-n150-processor) | Control plane and worker |
</div>

> [!NOTE]
> 
> Currently, the lab run off of a single node cluster with an intel N150 processor, with eventual plans to either add
> more mini-pcs or pi based solution on a single network switch. That said there is no worker node profile setup yet
> due to the single node setup.

### Services
```yaml
helm-managed-at-build-time:
    ingress-contoller:
        - name: tailscale
          helmrelease: https://pkgs.tailscale.com/helmcharts
secrets-manager:
    - sops
kubernetes-apps:
    tracking:
      - purpose: Apps that help keep track of things, including finances, passwords, and more.
        deployments:
            - name: Actual
              purpose: Tracking finnances
            - name: Vaultwarden
              purpose: Tracking passwords and accounts
```

# Installation

With nix installed, based on target node run

`sudo nixos-rebuild switch --flake .#<name>`
