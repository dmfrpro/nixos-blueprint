{ inputs, pkgs, ... }:

{
  _module.args = {
    secrets = import ../../secrets/secrets-eval.nix;
  };

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./networking

    ./audio.nix
    ./connectivity.nix
    ./desktop.nix
    ./input.nix
    ./shell.nix
    ./timezone.nix
    ./udev.nix
    ./virt.nix
  ];

  nix.settings = {
    trusted-users = [
      "root"
      "@wheel"
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
  };

  system.stateVersion = "26.05";

  programs.nix-ld.enable = true;
  services.envfs.enable = true;
}
