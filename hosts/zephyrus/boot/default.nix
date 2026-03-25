{ ... }:

{
  imports = [
    ./bootloader.nix
    ./initrd.nix
  ];

  boot.plymouth.enable = true;

  boot.kernel.sysctl."kernel.sysrq" = 1;
}
