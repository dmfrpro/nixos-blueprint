{ pkgs, ... }:

{
  programs.steam = {
    enable = true;

    package = pkgs.steam.override {
      extraProfile = ''
        export PROTON_ENABLE_WAYLAND=1
      '';
    };
  };

  environment.systemPackages = with pkgs; [ r2modman ];
}
