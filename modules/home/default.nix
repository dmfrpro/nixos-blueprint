{
  inputs,
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
    inputs.zen-browser.homeModules.twilight

    ./ghidra

    ./docker.nix
    ./git.nix
    ./gpg.nix
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
    };

    packages = with pkgs; [
      android-tools
      ayugram-desktop

      nur.repos.dmfrpro.auroraos-asbt-apptool
      nur.repos.dmfrpro.auroraos-platform-sdk
      nur.repos.dmfrpro.spflashtool5
      nur.repos.dmfrpro.spflashtool6
      nur.repos.dmfrpro.rkflashtool
      nur.repos.dmfrpro.upgrade_tool

      mtkclient
      picocom

      ida-pro

      zoom-us
    ];
  };
}
