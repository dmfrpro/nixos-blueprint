{ perSystem, ... }:

let
  lpmd = perSystem.self.intel-lpmd;
  mtlConfig = "intel_lpmd_config_F6_M170.xml";
in
{
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

    wantedBy = [
      "multi-user.target"
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
    ];

    after = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
    ];

    aliases = [ "org.freedesktop.intel_lpmd.service" ];
  };

  environment = {
    etc."intel_lpmd/${mtlConfig}".source = "${lpmd}/share/xml/${mtlConfig}";
    systemPackages = [ lpmd ];
  };
}
