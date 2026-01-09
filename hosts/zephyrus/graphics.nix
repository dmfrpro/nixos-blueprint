{ pkgs, modulesPath, ... }:

{
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.nvidia.prime.offload.enable = true;

  imports = [
    (modulesPath + "/hardware/cpu/intel-npu.nix")
  ];

  services.supergfxd = {
    enable = true;
    settings = {
      mode = "Hybrid";
      vfio_enable = true;
      vfio_save = false;
      always_reboot = false;
      no_logind = false;
      logout_timeout_s = 20;
      hotplug_type = "Asus";
    };
  };

  systemd.services.supergfxd.path = [
    pkgs.pciutils
  ];

  hardware.cpu.intel.npu.enable = true;
}
