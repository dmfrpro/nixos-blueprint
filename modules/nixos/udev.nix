{ pkgs, ... }:

{
  services.udev = {
    enable = true;
    packages = with pkgs.nur.repos.dmfrpro; [
      mtk-udev-rules
      rockchip-udev-rules
    ];
  };
}
