{ pkgs, perSystem, ... }:

let
  mkRebuildCommand = mode: {
    name = "rebuild-${mode}";
    help = "nixos-rebuild ${mode} with optional host argument";
    command = ''
      if [ $# -eq 0 ]; then
        echo "Usage: rebuild-${mode} <hostname>"
        exit 1
      fi
      sudo nixos-rebuild ${mode} --flake path:.#"$1"
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
        sudo nix-collect-garbage -d
        nix-collect-garbage -d
      '';
    }
  ];
}
