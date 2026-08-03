{ pkgs, ... }:

{
  boot = {
    # 7.1-7.2 kernels have regression
    # https://gitlab.freedesktop.org/drm/i915/kernel/-/commit/2914709c914101eb704e01bed2351070d4161ccf
    kernelPackages = pkgs.linuxPackages_6_18;

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
