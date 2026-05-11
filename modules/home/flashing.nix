{ pkgs, ... }:

let
  mtk = pkgs.mtkclient.overrideAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.hicolor-icon-theme ];

    desktopItems = [
      (pkgs.makeDesktopItem {
        name = "mtkclient";
        desktopName = "MTKClient";
        comment = "Mediatek Flash and Repair Utility";
        exec = "mtk_gui";
        icon = "mtkclient";
        categories = [ "Development" ];
      })
    ];

    postInstall = (old.postInstall or "") + ''
      for size in 32 64 256 512; do
        install -Dm644 $src/mtkclient/gui/images/logo_512.png \
          "$out/share/icons/hicolor/''${size}x''${size}/apps/mtkclient.png"
      done

      mkdir -p $out/share/mtkclient/images
      cp $src/mtkclient/gui/images/*.png $out/share/mtkclient/images/
    '';
  });
in
{
  home.packages = with pkgs; [
    android-tools
    picocom
    mtk
  ];
}
