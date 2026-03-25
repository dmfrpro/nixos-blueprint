{ ... }:

let
  windows-uuid = "f306bfd1-3b6e-4e2a-b12e-2367ffb3d161";
in
{
  boot.loader.limine = {
    enable = true;
    maxGenerations = 16;
    secureBoot.enable = false;
    style.interface.branding = " ";
    style.interface.resolution = "2560x1600";

    extraConfig = ''
      interface_help_hidden: yes
      remember_last_entry: yes
    '';
    extraEntries = ''
      /Windows
          protocol: efi
          path: uuid(${windows-uuid}):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  boot.loader.efi.canTouchEfiVariables = true;
}
