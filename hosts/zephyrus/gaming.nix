{ pkgs, ... }:

{
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession = {
      enable = true;
      args = [
        "-W"
        "2560"
        "-H"
        "1600"
        "-r"
        "240"
        "-f"
        "--adaptive-sync"
        "--hdr-enabled"
        "--hdr-debug-force-output"
      ];
    };

    package = pkgs.steam.override {
      extraProfile = ''
        export PROTON_ENABLE_WAYLAND=1
      '';
    };
  };

  programs.gamemode = {
    enable = true;
    enableRenice = true;
  };

  environment.systemPackages = with pkgs; [
    gamescope-wsi
    r2modman
  ];
}
