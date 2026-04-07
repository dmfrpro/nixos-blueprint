{ pkgs, ... }:

pkgs.stdenv.mkDerivation rec {
  pname = "zapret2";
  version = "0.9.4.7";

  src = pkgs.fetchFromGitHub {
    owner = "bol-van";
    repo = "zapret2";
    rev = "v${version}";
    hash = "sha256-GkwJZZRmn3ZjEa7jdxWEnfHMPfVHke8VhfeWeKMJUiw=";
  };

  buildInputs = with pkgs; [
    libcap
    libmnl
    libnetfilter_queue
    libnfnetlink
    lua
    luajit
    pkg-config
    zlib
  ];

  installPhase = ''
    mkdir -p $out/bin

    install -m755 nfq2/nfqws2 $out/bin/
    install -m755 ip2net/ip2net $out/bin/
    install -m755 mdig/mdig $out/bin/
  '';

  meta = {
    description = "DPI bypass multi platform";
    homepage = "https://github.com/bol-van/zapret";
    changelog = "https://github.com/bol-van/zapret/releases/tag/${src.tag}";
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.linux;
    mainProgram = "zapret2";
  };
}
