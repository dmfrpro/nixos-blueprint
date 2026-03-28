{ ... }:

{
  imports = [
    ./bootloader.nix
    ./initrd.nix
    ./kernel.nix
  ];

  boot.plymouth.enable = true;

  boot.kernel.sysctl."kernel.sysrq" = 1;
}
