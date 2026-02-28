{ pkgs, ... }:

let
  mkRebuildScript =
    mode:
    pkgs.writeShellScriptBin "rebuild-${mode}" ''
      if [ $# -eq 0 ]; then
        echo "Usage: rebuild-${mode} <hostname>"
        echo "Example: rebuild-${mode} zephyrus"
        exit 1
      fi
      sudo nixos-rebuild ${mode} --flake path:.#"$1"
    '';

  collect-garbage = pkgs.writeShellScriptBin "collect-garbage" ''
    sudo nix-collect-garbage -d
    nix-collect-garbage -d
  '';

  help = pkgs.writeShellScriptBin "help" ''
    BLUE="\033[1;34m"
    GREEN="\033[0;32m"
    NC="\033[0m" # No Color

    printf "''${BLUE}Available commands:''${NC}\n"
    printf "  ''${GREEN}rebuild-{switch,boot,test}''${NC} <hostname>\n"
    printf "  ''${GREEN}collect-garbage''${NC}\n"
  '';

in
pkgs.mkShell {
  packages = with pkgs; [
    bash
    direnv
    nix-direnv
    (mkRebuildScript "switch")
    (mkRebuildScript "boot")
    (mkRebuildScript "test")
    collect-garbage
    help
  ];

  shellHook = ''
    ${pkgs.bash}/bin/bash '${help}/bin/help'
  '';
}
