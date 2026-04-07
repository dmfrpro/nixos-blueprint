{ inputs, secrets, ... }:

{
  imports = [
    inputs.tg-ws-proxy.nixosModules.tg-ws-proxy
  ];

  services.tg-ws-proxy = {
    enable = true;
    secret = "${secrets.personal.tg-ws-proxy-secret}";
    noCfProxy = true;
  };
}
