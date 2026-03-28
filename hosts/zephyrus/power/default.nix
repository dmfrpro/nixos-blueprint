{ ... }:

{
  imports = [
    ./asus.nix
    ./lpmd.nix
    ./nvidia.nix
    ./suspend.nix
  ];

  services.power-profiles-daemon.enable = true;
}
