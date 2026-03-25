{ ... }:

{
  boot.initrd.systemd = {
    enable = true;
    tpm2.enable = true;
  };
}
