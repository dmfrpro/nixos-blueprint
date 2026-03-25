{ pkgs, ... }:

{
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

  systemd.services.supergfxd.path = with pkgs; [
    pciutils
  ];
}
