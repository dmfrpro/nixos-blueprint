{ ... }:

{
  boot.initrd = {
    systemd = {
      enable = true;
      tpm2.enable = true;
    };

    availableKernelModules = [
      "xhci_pci"
      "thunderbolt"
      "nvme"
      "usbhid"
      "usb_storage"
      "uas"
      "sd_mod"
      "rtsx_pci_sdmmc"
    ];
  };
}
