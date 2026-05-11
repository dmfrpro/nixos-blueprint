{ ... }:

{
  services.fstrim = {
    enable = true;
    interval = "weekly";
  };

  # Adios scheduler
  services.udev.extraRules = ''
    ACTION!="remove", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="adios"
  '';

}
