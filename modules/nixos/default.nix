{
  inputs,
  pkgs,
  ...
}:

{
  _module.args = {
    secrets = import ../../secrets/secrets-eval.nix;
  };

  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nur.modules.nixos.default
    inputs.determinate.nixosModules.default

    ./audio.nix
    ./bluetooth.nix
    ./desktop.nix
    ./input.nix
    ./networking.nix
    ./shell.nix
    ./timezone.nix
    ./virt.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.ida-pro-overlay.overlays.default
    inputs.nix-vscode-extensions.overlays.default
  ];

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
  };

  system.stateVersion = "26.05";
}
