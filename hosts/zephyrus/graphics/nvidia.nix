{ ... }:

{
  nixpkgs.config.nvidia.acceptLicense = true;

  services.xserver.videoDrivers = [
    "modesetting"
    "nvidia"
  ];

  hardware.nvidia = {
    open = true;

    prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };

    powerManagement = {
      enable = false;
      finegrained = false;
    };

    modesetting.enable = true;
    dynamicBoost.enable = false;
  };

  boot.blacklistedKernelModules = [
    "nouveau"
  ];

  # Backlight fixes
  boot.kernelParams = [
    "nvidia.NVreg_EnableBacklightHandler=0"
    "nvidia.NVReg_RegistryDwords=EnableBrightnessControl=0"
  ];
}
