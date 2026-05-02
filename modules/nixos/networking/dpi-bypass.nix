{ inputs, secrets, ... }:

{
  imports = [
    inputs.proxy-suite.nixosModules.default
  ];

  services.proxy-suite = {
    enable = true;
    singBox.enable = false;

    tgWsProxy = {
      enable = true;
      host = "127.0.0.1";
      port = 1443;
      secret = "${secrets.personal.tg-ws-proxy-secret}";
    };
    zapret = {
      enable = true;
      configName = "general (SIMPLE_FAKE_ALT2)";
    };
  };
}
