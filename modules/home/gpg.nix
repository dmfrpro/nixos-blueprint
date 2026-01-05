{ pkgs, ... }:

{
  programs.gpg.enable = true;

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    maxCacheTtl = 7200;
    extraConfig = ''
      allow-loopback-pinentry
    '';

    enableBashIntegration = true;
    enableZshIntegration = true;

    pinentry.package = pkgs.pinentry-gnome3;
    noAllowExternalCache = true;
  };
}
