{ inputs, secrets, ... }:

{
  imports = [
    inputs.proxy-suite.nixosModules.default
  ];

  services.proxy-suite = {
    enable = true;
    proxy.enable = false;

    tgWsProxy = {
      enable = true;
      secret = "${secrets.personal.tg-ws-proxy-secret}";
    };
    zapret.enable = true;
  };
}
