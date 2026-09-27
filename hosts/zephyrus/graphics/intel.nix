{ modulesPath, pkgs, ... }:

{
  imports = [
    (modulesPath + "/hardware/cpu/intel-npu.nix")
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

  # Backlight fixes
  boot.kernelParams = [
    "xe.force_probe=7d55"
    "xe.enable_dpcd_backlight=1"
  ];
}
