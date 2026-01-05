{ config, pkgs, ... }:

let
  ghidra-ext = pkgs.ghidra.withExtensions (
    p: with p; [
      kaiju
      ret-sync
      findcrypt
      machinelearning
      # gnudisassembler
      ghidra-firmware-utils
      ghidraninja-ghidra-scripts
      ghidra-delinker-extension
      ghidra-golanganalyzerextension
    ]
  );

  ghidra_dir = ".config/ghidra/${pkgs.ghidra.distroPrefix}";
  theme = ./oled.theme;
in
{
  home.packages = with pkgs; [
    ghidra-ext
    python313Packages.ghidra-bridge
    z3
  ];

  home.file = {
    "${ghidra_dir}/preferences".text = ''
      GhidraShowWhatsNew=false
      SHOW.HELP.NAVIGATION.AID=true
      SHOW_TIPS=false
      TIP_INDEX=0
      G_FILE_CHOOSER.ShowDotFiles=true
      USER_AGREEMENT=ACCEPT
      LastExtensionImportDirectory=${config.home.homeDirectory}/.config/ghidra/scripts/
      LastNewProjectDirectory=${config.home.homeDirectory}/.config/ghidra/repos/
      Theme=File\:${theme}
      ViewedProjects=
      RecentProjects=
    '';
  };

  systemd.user.tmpfiles.rules = [
    # https://www.man7.org/linux/man-pages/man5/tmpfiles.d.5.html
    "d %h/${ghidra_dir} 0700 - - -"
    "L+ %h/.config/ghidra/latest - - - - %h/${ghidra_dir}"
    "d %h/.config/ghidra/scripts 0700 - - -"
    "d %h/.config/ghidra/repos 0700 - - -"
  ];
}
