{ ... }:

let
  spec = builtins.fromJSON (builtins.readFile ./limine.json);
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
          path: uuid(${spec.windows-uuid}):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  boot.loader.efi.canTouchEfiVariables = true;
}
