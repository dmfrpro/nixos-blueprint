{ perSystem, ... }:

let
  tg-ws-proxy = perSystem.self.tg-ws-proxy;
in
{
  users.users.tg-ws-proxy = {
    isSystemUser = true;
    group = "tg-ws-proxy";
    createHome = false;
    description = "TG WS Proxy service user";
  };
  users.groups.tg-ws-proxy = { };

  systemd.services.tg-ws-proxy = {
    description = "Local SOCKS5 proxy for Telegram";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = "tg-ws-proxy";
      Group = "tg-ws-proxy";
      ExecStart = "${tg-ws-proxy}/bin/tg-ws-proxy --port 1080 --host 127.0.0.1";
      Restart = "on-failure";
      RestartSec = 5;
      StandardOutput = "journal";
      StandardError = "journal";
    };
  };
}
