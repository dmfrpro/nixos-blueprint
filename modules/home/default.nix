{
  pkgs,
  config,
  ...
}:

let
  ida-pro = pkgs.callPackage ./ida-pro.nix {
    inherit config;
    secrets = import ../../secrets/secrets-eval.nix;
  };
in
{
  _module.args = {
    secrets = import ../../secrets/secrets-eval.nix;
  };

  imports = [
    ./ghidra

    ./docker.nix
    ./firefox.nix
    ./git.nix
    ./gpg.nix
    ./keyring.nix
    ./shell.nix
    ./ssh.nix
    ./vesktop.nix
    ./vscode.nix
  ];

  nix.settings.lazy-trees = true;

  home = {
    stateVersion = "26.05";

    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    packages = with pkgs; [
      ayugram-desktop
      discord
      git

      nur.repos.dmfrpro.spflashtool5
      nur.repos.dmfrpro.spflashtool6
      nur.repos.dmfrpro.rkflashtool-fork
      nur.repos.dmfrpro.upgrade_tool

      mtkclient
      picocom

      ida-pro
    ];
  };
}
