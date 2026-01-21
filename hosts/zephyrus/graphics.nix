{
  config,
  pkgs,
  modulesPath,
  ...
}:

{
  nixpkgs.config.nvidia.acceptLicense = true;
  hardware.nvidia.prime.offload.enable = true;

  imports = [
    (modulesPath + "/hardware/cpu/intel-npu.nix")
  ];

  services.supergfxd = {
    enable = true;
    settings = {
      mode = "Integrated";
      vfio_enable = true;
      vfio_save = false;
      always_reboot = false;
      no_logind = true;
      logout_timeout_s = 20;
      hotplug_type = "Asus";
    };
  };

  systemd.services.supergfxd.path = [
    pkgs.pciutils
  ];

  hardware.cpu.intel.npu.enable = true;

  nixpkgs.overlays = [
    (_: super: {
      displaylink = super.displaylink.overrideAttrs (_: {
        version = "6.2.0-30";
        src = super.fetchurl {
          name = "displaylink-62.zip";
          url = "https://www.synaptics.com/sites/default/files/exe_files/2025-09/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.2-EXE.zip";
          hash = "sha256-JQO7eEz4pdoPkhcn9tIuy5R4KyfsCniuw6eXw/rLaYE=";
        };
      });
    })
  ];

  services.xserver.videoDrivers = [
    "displaylink"
    "modesetting"
  ];

  environment.systemPackages = with pkgs; [
    displaylink
  ];

  # Gnome-specific service
  systemd.services.dlm.wantedBy = [
    "multi-user.target"
  ];

  boot = {
    extraModulePackages = [
      config.boot.kernelPackages.evdi
    ];

    initrd = {
      kernelModules = [
        "evdi"
      ];
    };
  };
}
