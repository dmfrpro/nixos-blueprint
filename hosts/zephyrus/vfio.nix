{ pkgs, ... }:

{
  boot.kernelParams = [
    "iommu=pt"
    "intel_iommu=on"
    "i915.enable_guc=3"
    "i915.max_vfs=2"
    "i915.enable_dc=1"
    "kvm.ignore_msrs=1"
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

  # TODO: don't include igfx_off
  # virtualisation.vfio = {
  #   enable = true;
  #   IOMMUType = "intel";
  #   ignoreMSRs = true;
  # };

  virtualisation.kvmfr = {
    enable = true;
    devices = pkgs.lib.singleton {
      size = 128;
      permissions = {
        group = "qemu-libvirtd";
        mode = "0660";
      };
    };
  };

  virtualisation.libvirtd = {
    deviceACL = [
      "/dev/kvm"
      "/dev/kvmfr0"
      "/dev/kvmfr1"
      "/dev/shm/scream"
      "/dev/shm/looking-glass"
      "/dev/null"
      "/dev/full"
      "/dev/zero"
      "/dev/random"
      "/dev/urandom"
      "/dev/ptmx"
      "/dev/kvm"
      "/dev/kqemu"
      "/dev/rtc"
      "/dev/hpet"
      "/dev/vfio/vfio"
    ];
  };

  users.users.qemu-libvirtd.group = "qemu-libvirtd";
  users.groups.qemu-libvirtd = { };

  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];
}
