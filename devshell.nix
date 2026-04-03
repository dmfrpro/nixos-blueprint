{ pkgs, ... }:

pkgs.mkShell {
  packages = with pkgs; [
    nh
    coreutils
    just
  ];

  shellHook = ''
    just --list
  '';
}
