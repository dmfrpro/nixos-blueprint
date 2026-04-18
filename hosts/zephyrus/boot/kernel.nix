{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

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
