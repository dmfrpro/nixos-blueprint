{ ... }:

{
  imports = [
    ./asus.nix
    ./lpmd.nix
    ./suspend.nix
  ];

  services.power-profiles-daemon.enable = true;
}
