{ pkgs, ... }:

let
  pythonForIDA = pkgs.python313.withPackages (ps: with ps; [ rpyc ]);

  secrets = import ../../secrets/secrets-eval.nix;

  torrent = pkgs.fetchtorrent {
    url = secrets.ida-pro-url;
    hash = "sha256-pJ9bJGNkWwiUUqww3JSybGbvVd6kGo7H9SVogHCT+g8=";
    backend = "rqbit";
  };

  runfile = "${torrent}/installers/ida-pro_92_x64linux.run";
  keygen = "${torrent}/keygens_patchers/keygens by vovan2200/keygen.py";
  keygen_lumina = "${torrent}/keygens_patchers/keygens by vovan2200/keygen_lumina.py";
  keygen_vault = "${torrent}/keygens_patchers/keygens by vovan2200/keygen_vault.py";
in
pkgs.stdenv.mkDerivation rec {
  pname = "ida-pro";
  version = "9.2.0.250908";

  src = runfile;

  desktopItem = pkgs.makeDesktopItem {
    name = "ida-pro";
    exec = "ida";
    icon = ./icon.png;
    comment = meta.description;
    desktopName = "IDA Pro";
    genericName = "Interactive Disassembler";
    categories = [ "Development" ];
    startupWMClass = "IDA";
  };
  desktopItems = [ desktopItem ];

  nativeBuildInputs = with pkgs; [
    makeWrapper
    copyDesktopItems
    autoPatchelfHook
    qt6.wrapQtAppsHook
  ];

  dontUnpack = true;

  runtimeDependencies = with pkgs; [
    cairo
    dbus
    fontconfig
    freetype
    glib
    gtk3
    libdrm
    libGL
    libkrb5
    libsecret
    qt6.qtbase
    qt6.qtwayland
    libunwind
    libxkbcommon
    libsecret
    openssl.out
    stdenv.cc.cc
    libice
    libsm
    libx11
    libxau
    libxcb
    libxext
    libxi
    libxrender
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-wm
    zlib
    curl.out
    pythonForIDA
  ];
  buildInputs = runtimeDependencies;

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall

    function print_debug_info() {
      if [ -f installbuilder_installer.log ]; then
        cat installbuilder_installer.log
      else
        echo "No debug information available."
      fi
    }

    trap print_debug_info EXIT

    mkdir -p $out/bin $out/lib $out/opt/.local/share/applications

    # IDA depends on quite some things extracted by the runfile, so first extract everything
    # into $out/opt, then remove the unnecessary files and directories.
    IDADIR="$out/opt"
    # IDA doesn't always honor `--prefix`, so we need to hack and set $HOME here.
    HOME="$out/opt"

    # Invoke the installer with the dynamic loader directly, avoiding the need
    # to copy it to fix permissions and patch the executable.
    $(cat $NIX_CC/nix-support/dynamic-linker) $src \
      --mode unattended --debuglevel 4 --prefix $IDADIR

    # Link the exported libraries to the output.
    for lib in $IDADIR/*.so $IDADIR/*.so.6; do
      ln -s $lib $out/lib/$(basename $lib)
    done

    # Manually patch libraries that dlopen stuff.
    patchelf --add-needed libpython3.13.so $out/lib/libida.so
    patchelf --add-needed libcrypto.so $out/lib/libida.so
    patchelf --add-needed libsecret-1.so.0 $out/lib/libida.so

    # Some libraries come with the installer.
    addAutoPatchelfSearchPath $IDADIR

    # Link the binaries to the output.
    # Also, hack the PATH so that pythonForIDA is used over the system python.
    for bb in ida; do
      wrapProgram $IDADIR/$bb \
        --prefix IDADIR : $IDADIR \
        --prefix QT_PLUGIN_PATH : $IDADIR/plugins/platforms \
        --prefix PYTHONPATH : $out/bin/idalib/python \
        --prefix PATH : ${pythonForIDA}/bin:$IDADIR \
        --prefix LD_LIBRARY_PATH : $out/lib
      ln -s $IDADIR/$bb $out/bin/$bb
    done

    runHook postInstall
  '';

  postFixup = ''
    cd $out/opt && ${pkgs.python313}/bin/python '${keygen}'
    cd $out/opt && ${pkgs.python313}/bin/python '${keygen_lumina}'
    cd $out/opt && ${pkgs.python313}/bin/python '${keygen_vault}'
  '';

  meta = {
    license = pkgs.lib.licenses.mit;
    description = "The world's smartest and most feature-full disassembler";
    homepage = "https://hex-rays.com/ida-pro/";

    mainProgram = "ida";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
  };
}
