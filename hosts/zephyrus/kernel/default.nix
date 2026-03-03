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
    "intel_iommu=on"
    "i915.enable_guc=3"
    "i915.max_vfs=7"
    "i915.force_probe=0x7d55"
    "i915.enable_dc=1"
  ];

  boot.blacklistedKernelModules = [
    "nouveau"
    "xe"
  ];

  systemd.services.i915-sriov = {
    description = "Enable i915 SRIOV";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    requires = [ "systemd-modules-load.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      I915_PATH=/sys/devices/pci0000:00/0000:00:02.0
      NUMVFS=$(cat "$I915_PATH/sriov_totalvfs")
      echo 0 > "$I915_PATH/sriov_drivers_autoprobe"
      echo "$NUMVFS" > "$I915_PATH/sriov_numvfs"

      ${pkgs.lib.getExe' pkgs.kmod "modprobe"} -v vfio-pci

      for VF in $I915_PATH/virtfn*; do
        PCI_ADDR=$(readlink -f $VF)
        PCI_ADDR=''${PCI_ADDR##*/}
        echo vfio-pci > "$VF/driver_override"
        echo "$PCI_ADDR" > /sys/bus/pci/drivers_probe
      done
    '';
  };
}
