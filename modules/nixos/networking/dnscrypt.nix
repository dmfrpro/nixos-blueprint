{ ... }:

{
  services.dnscrypt-proxy = {
    enable = true;
    settings = {
      listen_addresses = [ "127.0.0.1:5354" ];
      server_names = [
        "cloudflare"
        "google"
      ];
    };
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNS = "127.0.0.1:5354";
      DNSStubListener = "no";
    };
  };

  environment.etc."resolv.conf".mode = "direct-symlink";
  networking.networkmanager.dns = "systemd-resolved";
}
