{ pkgs, ... }:

let
  asusConfig = {
    name = "asus-linux";
    patch = null;
    extraConfig = ''
      ASUS_ARMOURY m
    '';
  };
in
{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelPatches = [ asusConfig ];

    kernelModules = [
      "nvme"
      "cryptd"
      "aesni_intel"
      "kvm-intel"
    ];

    kernelParams = [
      "quiet"
      "rhgb"
      "nowatchdog"
      "nvme_load=YES"
    ];
  };
}
