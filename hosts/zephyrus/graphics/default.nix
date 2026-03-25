{ ... }:

{
  imports = [
    ./intel.nix
    ./nvidia.nix
    ./supergfx.nix
  ];

  hardware.graphics.enable = true;
}
