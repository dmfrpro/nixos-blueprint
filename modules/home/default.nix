{ inputs, pkgs, ... }:

{
  _module.args = {
    secrets = import ../../secrets/secrets-eval.nix;
  };

  imports = [
    inputs.zen-browser.homeModules.twilight

    ./ghidra
    ./docker.nix
    ./git.nix
    ./gpg.nix
    ./flashing.nix
    ./keyring.nix
    ./shell.nix
    ./ssh.nix
    ./vesktop.nix
    ./vscode.nix
    ./zen.nix
  ];

  home = {
    stateVersion = "26.05";

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
      NIXPKGS_ALLOW_UNFREE = "1";
      NIXPKGS_ALLOW_INSECURE = "1";
    };

    packages =
      with pkgs;
      [
        telegram-desktop
        zoom-us
        devenv

        # perSystem.self.ida-pro
      ];
  };
}
