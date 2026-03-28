{ config, pkgs, ... }:

{
  boot.kernelParams = [
    "mem_sleep_default=deep"
  ];

  systemd.sleep.settings.Sleep = {
    HibernateDelaySec = "30m";
    SuspendState = "mem";
  };

  # https://github.com/NixOS/nixpkgs/issues/273053
  boot.resumeDevice = pkgs.lib.mkIf (
    builtins.length config.swapDevices == 1
  ) (builtins.head config.swapDevices).device;
}
