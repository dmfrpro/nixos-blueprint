{ pkgs, ... }:

{
  imports = [
    ./dnscrypt.nix
    ./dpi-bypass.nix
    ./omp.nix
    ./snejugal.nix
    ./tg-ws-proxy.nix
  ];

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";

      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    firewall.checkReversePath = false;
    enableIPv6 = false;
  };

  programs.mtr.enable = true;
  programs.nm-applet.enable = true;
}
