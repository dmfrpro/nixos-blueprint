{
  inputs,
  flake,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    flake.nixosModules.default

    ./boot
    ./graphics
    ./power

    ./disko.nix
    ./filesystem.nix
    ./gaming.nix
    ./keyboard.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
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
      "gamemode"
      "tss"
    ];
  };

  nix.settings.trusted-users = [ "dmfrpro" ];
}
