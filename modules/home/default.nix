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

  auroraSdk = with pkgs.nur.repos.dmfrpro; [
    auroraos-asbt-apptool
    auroraos-platform-sdk
  ];
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
    };

    packages =
      with pkgs;
      [
        ayugram-desktop
        zoom-us

        # Custom IDA Pro
        ida-pro
      ]
      ++ auroraSdk;
  };
}
