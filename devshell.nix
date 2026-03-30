{ pkgs, ... }:

let
  mkRebuildApp =
    mode:
    pkgs.writeShellApplication {
      name = mode;

      runtimeInputs = with pkgs; [
        nh
        coreutils
      ];

      text = ''
        nh os ${mode} path:./#"$(hostname)"
      '';
    };

  gc = pkgs.writeShellApplication {
    name = "gc";
    runtimeInputs = with pkgs; [ nh ];
    text = ''
      nh clean all
    '';
  };

  commands = [
    (mkRebuildApp "switch")
    (mkRebuildApp "boot")
    gc
  ];

  help = pkgs.writeShellApplication {
    name = "help";

    runtimeInputs = with pkgs; [ coreutils ];

    text =
      let
        entries = builtins.concatStringsSep "\n" (
          map (
            pkg:
            let
              exe = pkgs.lib.getExe pkg;
            in
            ''
              name="$(${pkgs.coreutils}/bin/basename ${exe})"
              # Use %b for color variables so \033 is interpreted
              printf "  - %b%s%b\n" "$GREEN" "$name" "$NC"
            ''
          ) commands
        );
      in
      ''
        BLUE="\033[1;34m"
        GREEN="\033[0;32m"
        NC="\033[0m"

        printf "%bAvailable commands:%b\n" "$BLUE" "$NC"
        ${entries}
      '';
  };

in
pkgs.mkShell {
  packages = commands ++ [ help ];

  shellHook = ''
    ${pkgs.bash}/bin/bash '${help}/bin/help'
  '';
}
