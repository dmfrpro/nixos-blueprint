{ pkgs, ... }:

{
  boot.kernelPackages = pkgs.callPackage ./linux-g14.nix { };

  boot.kernelModules = [
    "nvme"
    "cryptd"
    "aesni_intel"
    "kvm-intel"
  ];

  boot.extraModulePackages = with pkgs; [ i915-sriov ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "thunderbolt"
    "nvme"
    "usbhid"
    "usb_storage"
    "uas"
    "sd_mod"
    "rtsx_pci_sdmmc"
  ];

  boot.kernelParams = [
    "quiet"
    "rhgb"
    "nowatchdog"
    "nvme_load=YES"
  ];

  boot.blacklistedKernelModules = [
    "nouveau"
    "xe"
  ];
}
