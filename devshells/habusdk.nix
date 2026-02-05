{ inputs, perSystem, ... }:

let
  system = perSystem.nixpkgs.stdenv.hostPlatform.system;

  pkgs = import inputs.nixpkgs {
    inherit system;
    config.permittedInsecurePackages = [
      "python-2.7.18.12"
      "python-2.7.18.12-env"
    ];
  };

  customStdenv = pkgs.stdenvAdapters.overrideCC pkgs.stdenv (
    pkgs.wrapCCWith {
      cc = pkgs.gcc-unwrapped;
      libc = pkgs.glibc_multi;
      bintools = pkgs.wrapBintoolsWith {
        bintools = pkgs.binutils-unwrapped;
        libc = pkgs.glibc_multi;
      };
    }
  );

in
(pkgs.buildFHSEnv {
  name = "habusdk";

  stdenv = customStdenv;

  extraOutputsToInstall = [
    "out"
    "dev"
    "lib"
    "static"
  ];
  multiArch = true;

  nativeBuildInputs = with pkgs; [ sssd ];

  targetPkgs =
    p: with p; [
      gnumake
      cmake
      ninja
      bc
      bison
      flex
      m4
      dtc
      pkg-config

      # Custom wrapped gcc
      gcc

      android-tools
      jdk
      python2
      python3
      perl
      perl5Packages.Switch
      coreutils-full
      findutils
      git
      git-repo
      git-lfs
      curl
      rsync
      procps
      util-linux
      schedtool
      gnupg
      zip
      unzip
      lz4
      lzop
      squashfsTools
      ncurses5
      readline
      libxml2
      libxslt
      elfutils
      yaml-cpp
      freetype
      fontconfig
      libxcrypt-legacy
      openssl
      zlib
      direnv
      zsh
    ];

  multiPkgs =
    pkgs: with pkgs; [
      zlib
      ncurses5
      readline
    ];

  profile = ''
    export ALLOW_NINJA_ENV=true
    export ANDROID_JAVA_HOME="${pkgs.jdk.home}"
    export PERL5LIB="${pkgs.perl5Packages.Switch}/lib/perl5/site_perl"
    export TMPDIR="/tmp"

    export LIBRARY_PATH="/usr/lib64:/usr/lib32:/usr/lib"
    export C_INCLUDE_PATH="/usr/include"
    export CPLUS_INCLUDE_PATH="/usr/include"

    export HOSTCC=gcc
    export HOSTCXX=g++
    export HOSTAR=ar
    export HOSTLD=ld
    export HOSTNM=nm
    export HOSTOBJCOPY=objcopy
    export HOSTOBJDUMP=objdump
    export HOSTRANLIB=ranlib
    export HOSTSTRIP=strip
    export HOSTREADELF=readelf

    export HOSTCFLAGS="-B/usr/lib64 -B/usr/lib32 -I/usr/include"
    export HOSTCXXFLAGS="-B/usr/lib64 -B/usr/lib32 -I/usr/include"
    export HOSTLDFLAGS="-L/usr/lib64 -L/usr/lib32 -L/usr/lib"
    export HOSTLDLIBS=""

    export LD_LIBRARY_PATH="/usr/lib64:/usr/lib32:/usr/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export LD_LIBRARY_PATH="${pkgs.sssd}/lib:''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
  '';

  runScript = "zsh";
}).env
