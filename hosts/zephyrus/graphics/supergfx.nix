{ pkgs, ... }:

{
  services.supergfxd = {
    enable = true;
    settings = {
      mode = "Hybrid";
      vfio_enable = true;
      vfio_save = false;
      always_reboot = false;
      no_logind = true;
      logout_timeout_s = 20;
      hotplug_type = "None";
    };
  };

  systemd.services.supergfxd.path = with pkgs; [
    pciutils
  ];
}
