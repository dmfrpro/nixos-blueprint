{
  inputs,
  flake,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.i915-sriov.nixosModules.default
    flake.nixosModules.default

    ./boot
    ./graphics
    ./power

    ./disko.nix
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
    ];
  };

  nix.settings.trusted-users = [ "dmfrpro" ];
}
