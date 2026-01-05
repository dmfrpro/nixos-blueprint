{ ... }:

{
  powerManagement.enable = true;

  services.power-profiles-daemon.enable = true;
  services.logind.settings.Login.LidSwitch = "suspend-then-hibernate";
  services.logind.settings.Login.PowerKey = "hibernate";
  services.logind.settings.Login.PowerKeyLongPress = "poweroff";

  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  systemd.sleep.extraConfig = ''
    HibernateDelaySec=30m
    SuspendState=mem
  '';
}
