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
    inputs.zapret-discord-youtube.nixosModules.default

    ./audio.nix
    ./bluetooth.nix
    ./desktop.nix
    ./input.nix
    ./networking.nix
    ./shell.nix
    ./timezone.nix
    ./udev.nix
    ./virt.nix
  ];

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    inputs.ida-pro-overlay.overlays.default
    inputs.nix-vscode-extensions.overlays.default
  ];

  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://numtide.cachix.org"
      "https://nix-community.cachix.org"
      "https://install.determinate.systems"
      "https://attic.services.itssho.my/umbra"
      "https://devenv.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
      "umbra:hogFc/tNDw5cXhdBfFagDNEEiR6NGspXBzyVJhzka/4="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];

    experimental-features = [
      "nix-command"
      "flakes"
    ];

    trusted-users = [
      "root"
      "@wheel"
    ];
  };

  users = {
    mutableUsers = true;
    defaultUserShell = pkgs.zsh;
  };

  system.stateVersion = "26.05";
}
