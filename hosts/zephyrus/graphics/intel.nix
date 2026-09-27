{
  config,
  inputs,
  modulesPath,
  pkgs,
  ...
}:

{
  imports = [
    (modulesPath + "/hardware/cpu/intel-npu.nix")
    inputs.i915-sriov.nixosModules.default
  ];

  hardware.cpu.intel.npu.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    intel-compute-runtime
    vpl-gpu-rt
    intel-ocl
  ];

  hardware.graphics.extraPackages32 = with pkgs.driversi686Linux; [
    intel-media-driver
  ];

  boot.initrd.kernelModules = [
    "xe"
  ];

  boot.blacklistedKernelModules = [
    "i915"
  ];

  boot.kernelParams = [
    "xe.force_probe=7d55"

    # Backlight fixes
    "xe.enable_dpcd_backlight=1"

    # SR-IOV VFIO
    "iommu=pt"
    "intel_iommu=on"
    "intel_iommu=on"
    "xe.enable_guc=3"
    "xe.max_vfs=1"
    "xe.enable_dc=1"
    "kvm.ignore_msrs=1"
  ];

  boot.extraModulePackages = [ 
    config.boot.kernelPackages.kvmfr
    pkgs.xe-sriov
  ];

  boot.kernelModules = [ "kvmfr" ];
  boot.extraModprobeConfig = ''
    options kvmfr static_size_mb=128
  '';

  services.udev.extraRules = ''
    SUBSYSTEM=="kvmfr", KERNEL=="kvmfr0", OWNER="root", GROUP="qemu-libvirtd", MODE="0660", TAG+="systemd"
  '';

  environment.etc."apparmor.d/local/abstractions/libvirt-qemu" =
    pkgs.lib.mkIf config.security.apparmor.enable {
      text = "/dev/kvmfr0 rw";
    };

  virtualisation.libvirtd.qemu.verbatimConfig = ''
    clear_emulation_capabilities = 1
    cgroup_device_acl = [
      "/dev/kvm",
      "/dev/kvmfr0",
      "/dev/shm/scream",
      "/dev/shm/looking-glass",
      "/dev/null",
      "/dev/full",
      "/dev/zero",
      "/dev/random",
      "/dev/urandom",
      "/dev/ptmx",
      "/dev/kqemu",
      "/dev/rtc",
      "/dev/hpet",
      "/dev/vfio/vfio"
    ]
  '';

  users.users.qemu-libvirtd.group = "qemu-libvirtd";
  users.groups.qemu-libvirtd = { };

  environment.systemPackages = with pkgs; [
    looking-glass-client
  ];

  systemd.services.xe-sriov = {
    description = "Enable Xe SRIOV";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-modules-load.service" ];
    requires = [ "systemd-modules-load.service" ];
    serviceConfig.Type = "oneshot";
    script = ''
      XE_PATH=/sys/devices/pci0000:00/0000:00:02.0
      NUMVFS=$(cat "$XE_PATH/sriov_totalvfs")
      echo 0 > "$XE_PATH/sriov_drivers_autoprobe"
      echo "$NUMVFS" > "$XE_PATH/sriov_numvfs"

      ${pkgs.lib.getExe' pkgs.kmod "modprobe"} -v vfio-pci

      for VF in $XE_PATH/virtfn*; do
        PCI_ADDR=$(readlink -f $VF)
        PCI_ADDR=''${PCI_ADDR##*/}
        echo vfio-pci > "$VF/driver_override"
        echo "$PCI_ADDR" > /sys/bus/pci/drivers_probe
      done
    '';
  };
}
