{ pkgs, ... }:

{
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  environment.gnome.excludePackages = with pkgs; [
    baobab
    cheese
    eog
    epiphany
    gedit
    simple-scan
    totem
    yelp
    evince
    file-roller
    geary

    gnome-calculator
    gnome-calendar
    gnome-characters
    gnome-console
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-system-monitor
    gnome-terminal
    gnome-weather
    gnome-disk-utility
  ];

  services.gnome.gnome-keyring.enable = true;
  security.pam.services.login.enableGnomeKeyring = true;
}
