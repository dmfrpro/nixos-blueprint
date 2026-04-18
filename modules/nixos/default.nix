{ inputs, pkgs, ... }:

{
  _module.args = {
    secrets = import ../../secrets/secrets-eval.nix;
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    inputs.determinate.nixosModules.default
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

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.nix-vscode-extensions.overlays.default
  ];

  nix.settings.trusted-users = [
    "root"
    "@wheel"
  ];

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
  };

  system.stateVersion = "26.05";
}
