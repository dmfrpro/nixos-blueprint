{ pkgs, secrets, ... }:

{
  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";

      plugins = with pkgs; [
        networkmanager-openvpn
      ];
    };

    firewall.checkReversePath = false;
  };

  programs.mtr.enable = true;
  programs.nm-applet.enable = true;

  services.resolved.enable = true;
  environment.etc."resolv.conf".mode = "direct-symlink";

  networking.networkmanager.ensureProfiles.profiles.snejugal = {
    connection = {
      id = "snejugal";
      uuid = "925144ce-8d10-49d0-a31f-0928ea4ca9df";
      type = "wireguard";
      autoconnect = false;
      interface-name = "snejugal";
      timestamp = "1760820695";
    };

    wireguard = {
      listen-port = 51820;
      private-key = secrets.vpn.snejugal.private-key;
    };

    "wireguard-peer.${secrets.vpn.snejugal.wireguard-peer}" = {
      endpoint = secrets.vpn.snejugal.endpoint;
      preshared-key = secrets.vpn.snejugal.preshared-key;
      preshared-key-flags = 0;
      persistent-keepalive = 16;
      allowed-ips = "0.0.0.0/0;::/0;";
    };

    ipv4 = {
      address1 = secrets.vpn.snejugal.ipv4-address;
      dns = secrets.vpn.snejugal.ipv4-dns;
      dns-search = "~";
      method = "manual";
    };

    ipv6 = {
      addr-gen-mode = "default";
      address1 = secrets.vpn.snejugal.ipv6-address;
      method = "manual";
    };
  };

  security.pki.certificateFiles = [
    ../../secrets/omp-ca.crt
  ];

  services.zapret-discord-youtube = {
    enable = true;
    configName = "general (SIMPLE_FAKE_ALT2)";
  };
}
