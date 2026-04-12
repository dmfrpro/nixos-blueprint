{ inputs, secrets, ... }:

{
  imports = [
    inputs.tg-ws-proxy.nixosModules.tg-ws-proxy
    inputs.zapret2.nixosModules.default
  ];

  services.zapret2 = {
    enable = true;
    configureFirewall = true;
    firewallPostCommands = ''
      ip46tables -t mangle -I OUTPUT 1 -d 149.154.167.0/24 -j CONNMARK --set-mark 0x40000000/0x40000000
      ip46tables -t mangle -I OUTPUT 1 -d 149.154.175.0/24 -j CONNMARK --set-mark 0x40000000/0x40000000
      ip46tables -t mangle -I OUTPUT 1 -d 91.108.56.0/22    -j CONNMARK --set-mark 0x40000000/0x40000000
      ip46tables -t mangle -I POSTROUTING 1 -m connmark --mark 0x40000000/0x40000000 -j MARK --set-mark 0x40000000/0x40000000
      ip46tables -t mangle -I FORWARD 1 -d 149.154.167.0/24 -j CONNMARK --set-mark 0x40000000/0x40000000
    '';
  };

  services.tg-ws-proxy = {
    enable = true;
    secret = "${secrets.personal.tg-ws-proxy-secret}";
    noCfProxy = true;
  };
}
