{
  pkgs,
  fetchtorrent,
  secrets,
  ...
}:

let
  torrent = fetchtorrent {
    url = secrets.ida-pro-url;
    hash = "sha256-pJ9bJGNkWwiUUqww3JSybGbvVd6kGo7H9SVogHCT+g8=";
    backend = "rqbit";
  };

  runfile = "${torrent}/installers/ida-pro_92_x64linux.run";
  keygen = "${torrent}/keygens_patchers/keygens by vovan2200/keygen.py";
  keygen_lumina = "${torrent}/keygens_patchers/keygens by vovan2200/keygen_lumina.py";
  keygen_vault = "${torrent}/keygens_patchers/keygens by vovan2200/keygen_vault.py";

  ida-pro = pkgs.callPackage pkgs.ida-pro {
    runfile = runfile;
  };
in
ida-pro.overrideAttrs (oldAttrs: {
  postFixup = (oldAttrs.postFixup or "") + ''
    cd $out/opt && ${pkgs.python313}/bin/python '${keygen}'
    cd $out/opt && ${pkgs.python313}/bin/python '${keygen_lumina}'
    cd $out/opt && ${pkgs.python313}/bin/python '${keygen_vault}'
  '';
})
