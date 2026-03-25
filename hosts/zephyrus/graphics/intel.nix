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
    "i915"
  ];

  boot.blacklistedKernelModules = [
    "xe"
  ];

  # Backlight fixes
  boot.kernelParams = [
    "i915.enable_dpcd_backlight=1"
  ];
}
