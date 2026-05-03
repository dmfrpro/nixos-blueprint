{ pkgs, ... }:

let
  linuxUrl = "https://raw.githubusercontent.com/torvalds/linux";
  linuxRev = "f9569c6ce4a4bbad0876ca7bd1e04fbfbbc1641f";

  codespellUrl = "https://raw.githubusercontent.com/codespell-project/codespell";
  codespellRev = "06a094750a46469f3c6a9a35428291d8573a9127";
in
pkgs.stdenv.mkDerivation {
  pname = "checkpatch";
  version = "7.1.-rc1";

  checkpatchSrc = pkgs.fetchurl {
    url = "${linuxUrl}/${linuxRev}/scripts/checkpatch.pl";
    hash = "sha256-40v1zsEsGiCLYBzYY90XU2cQpo4/Ecbg1PtL9yJDkC4=";
  };

  spellingTxt = pkgs.fetchurl {
    url = "${linuxUrl}/${linuxRev}/scripts/spelling.txt";
    hash = "sha256-tdYwD9xajyNdTQUsi7W56dLOOt/NyJJeynLrRaEJLhQ=";
  };

  constStructs = pkgs.fetchurl {
    url = "${linuxUrl}/${linuxRev}/scripts/const_structs.checkpatch";
    hash = "sha256-6gZPaRanR2NGgDdJSusnCq40t8l2F+hNQkyluHM1ObI=";
  };

  codespellDict = pkgs.fetchurl {
    url = "${codespellUrl}/${codespellRev}/codespell_lib/data/dictionary.txt";
    hash = "sha256-cs0gFASw0pcR6T1o9QYwnt1VUG4l7SkrPLzsBrzYJio=";
  };

  nativeBuildInputs = with pkgs; [
    makeWrapper
    perl
    perlPackages.FileSlurp
    perlPackages.TermANSIColor
  ];

  dontUnpack = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/share/checkpatch

    install -m 0644 $checkpatchSrc $out/share/checkpatch/checkpatch.pl
    install -m 0644 $spellingTxt $out/share/checkpatch/spelling.txt
    install -m 0644 $constStructs $out/share/checkpatch/const_structs.checkpatch
    install -m 0644 $codespellDict $out/share/checkpatch/dictionary.txt

    substituteInPlace $out/share/checkpatch/checkpatch.pl \
      --replace-fail "/usr/share/codespell/dictionary.txt" \
      "$out/share/checkpatch/dictionary.txt"

    mkdir -p $out/bin
    makeWrapper ${pkgs.perl}/bin/perl $out/bin/checkpatch.pl \
      --add-flags "$out/share/checkpatch/checkpatch.pl"
  '';

  meta = with pkgs.lib; {
    description = "Linux kernel checkpatch.pl";
    homepage = "https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git";
    license = licenses.gpl2Only;
    platforms = platforms.all;
  };
}
