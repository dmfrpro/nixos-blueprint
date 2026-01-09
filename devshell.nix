{ pkgs, perSystem, ... }:

let
  substituters = [
    "https://cache.nixos.org"
    "https://numtide.cachix.org"
    "https://nix-community.cachix.org"
    "https://install.determinate.systems"
    "https://cache.nixos-cuda.org"
  ];

  trustedPublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    "cache.flakehub.com-3:hJuILl5sVK4iKm86JzgdXW12Y2Hwd5G07qKtHTOcDCM="
    "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
  ];

  substitutersStr = builtins.concatStringsSep " " substituters;
  trustedPublicKeysStr = builtins.concatStringsSep " " trustedPublicKeys;

  mkRebuildCommand = mode: {
    name = "rebuild-${mode}";
    help = "nixos-rebuild ${mode} with optional host argument";
    command = ''
      if [ $# -eq 0 ]; then
        echo "Usage: rebuild-${mode} <hostname>"
        echo "Example: rebuild-${mode} zephyrus"
        exit 1
      fi

      sudo nixos-rebuild ${mode} \
        --option substituters "${substitutersStr}" \
        --option trusted-public-keys "${trustedPublicKeysStr}" \
        --option experimental-features 'nix-command flakes' \
        --flake path:.#"$1"
    '';
  };

in
perSystem.devshell.mkShell {
  packages = with pkgs; [
    direnv
    nix-direnv
  ];

  commands = [
    (mkRebuildCommand "switch")
    (mkRebuildCommand "boot")
    (mkRebuildCommand "test")

    {
      name = "collect-garbage";
      help = "nix garbage collection";
      command = ''
        sudo nix-collect-garbage
        sudo nix-store --optimise
      '';
    }
  ];
}
