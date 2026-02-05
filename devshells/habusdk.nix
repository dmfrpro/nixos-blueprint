{ pkgs, ... }:

let
  androidFHSEnv = pkgs.buildFHSEnv {
    name = "habusdk-fhs";
    
    targetPkgs = pkgs: with pkgs; [
      android-tools
      libxcrypt-legacy
      freetype
      fontconfig
      yaml-cpp
      
      python2
      perl5Packages.Switch
      
      bc
      binutils
      bear
      bison
      ccache
      curl
      flex
      dtc
      gcc
      git
      git-repo
      git-lfs
      gnumake
      gnupg
      gperf
      imagemagick
      jdk
      just
      elfutils
      libxml2
      libxslt
      lz4
      lzop
      m4
      nettools
      openssl
      openssl.dev
      perl
      pngcrush
      procps
      python3
      rsync
      schedtool
      SDL
      squashfsTools
      unzip
      util-linux
      xml2
      zip
      zsh
    ];
    
    multiPkgs = pkgs: with pkgs; [
      zlib
      ncurses5
      libcxx
      readline
      libgcc
      iconv
      iconv.dev
    ];
    
    profile = ''
      export PERL5LIB="${pkgs.perl5Packages.Switch}/lib/perl5/site_perl"
      export LD_LIBRARY_PATH="${pkgs.lib.makeLibraryPath [
        pkgs.ncurses5
        pkgs.zlib
        pkgs.libxcrypt-legacy
        pkgs.freetype
        pkgs.fontconfig
        pkgs.yaml-cpp
      ]}:$LD_LIBRARY_PATH"
    '';
    
    runScript = "zsh";
  };

in
pkgs.mkShell.override { stdenv = pkgs.gccMultiStdenv; } {
  name = "habusdk";
  
  packages = [
    androidFHSEnv
  ];
  
  env = {
    ANDROID_JAVA_HOME = "${pkgs.jdk.home}";
    TMPDIR = "/tmp";
  };
  
  shellHook = "exec habusdk-fhs";
}