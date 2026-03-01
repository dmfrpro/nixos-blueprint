{ perSystem, ... }:

let
  lpmd = perSystem.self.intel-lpmd;
  mtlConfig = "intel_lpmd_config_F6_M170.xml";
in
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

  systemd.services.intel-lpmd = {
    description = "Intel Linux Energy Optimizer (lpmd) Service";
    documentation = [ "man:intel_lpmd(8)" ];

    unitConfig = {
      ConditionVirtualization = "no";
      StartLimitIntervalSec = 200;
      StartLimitBurst = 5;
    };

    serviceConfig = {
      Type = "dbus";
      SuccessExitStatus = 2;
      BusName = "org.freedesktop.intel_lpmd";
      ExecStart = "${lpmd}/bin/intel_lpmd --systemd --dbus-enable";
      Restart = "on-failure";
      RestartSec = 30;
      PrivateTmp = true;
    };

    wantedBy = [ "multi-user.target" ];
    aliases = [ "org.freedesktop.intel_lpmd.service" ];
  };

  environment = {
    etc."intel_lpmd/${mtlConfig}".source = "${lpmd}/share/xml/${mtlConfig}";
    systemPackages = [ lpmd ];
  };
}
