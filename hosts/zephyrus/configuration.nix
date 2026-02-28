{
  inputs,
  flake,
  ...
}:

let
  facter = builtins.fromJSON (builtins.readFile ./facter.json);
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-hardware.nixosModules.asus-zephyrus-gu605my
    flake.nixosModules.default

    ./kernel
    ./bootloader.nix
    ./disko.nix
    ./graphics.nix
    ./power.nix
  ];

  nixpkgs.hostPlatform = facter.system;
  system.stateVersion = "26.05";

  hardware.enableAllFirmware = true;
  hardware.cpu.intel.updateMicrocode = true;

  networking.hostName = "zephyrus";

  users.users.dmfrpro = {
    isNormalUser = true;
    createHome = true;
    extraGroups = [
      "adbusers"
      "wheel"
      "networkmanager"
      "input"
      "libvirtd"
      "kvm"
      "dialout"
      "plugdev"
      "docker"
    ];
  };

  nix.settings.trusted-users = [ "dmfrpro" ];
}
