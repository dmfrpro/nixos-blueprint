{ pkgs, perSystem, ... }:

pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } rec {
  packages = with pkgs; [
    gnumake
    cmake
    bear

    clang
    clang-tools
    clang-analyzer
    libclang
    rtags

    lldb
    perSystem.pwndbg.pwndbg-lldb

    cppcheck
    valgrind
  ];
}
