{ pkgs, perSystem, ... }:

let
  magiskZapret2 = pkgs.fetchFromGitHub {
    owner = "youtubediscord";
    repo = "magisk-zapret2";
    rev = "v1.9.119001";
    hash = "sha256-Zy1MkD1eBhaLPH383r90AVNbp+cLOQXZZcxdhWUXrAI=";
  };

  fileExists = relPath: builtins.pathExists "${magiskZapret2}/zapret2/${relPath}";
  dataPath = "${zapret2WithData}/share/zapret2";

  zapret2WithData = pkgs.symlinkJoin {
    name = "zapret2-with-data";
    paths = [ perSystem.self.zapret2 ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      mkdir -p $out/share/zapret2
      ln -s ${magiskZapret2}/zapret2/lua    $out/share/zapret2/lua
      ln -s ${magiskZapret2}/zapret2/bin    $out/share/zapret2/bin
      ln -s ${magiskZapret2}/zapret2/lists  $out/share/zapret2/lists
    '';
  };

  absPath = rel: "${dataPath}/${rel}";

  processLuaInit =
    line:
    let
      raw = pkgs.lib.removePrefix "--lua-init=" line;
      file = if pkgs.lib.hasPrefix "@" raw then pkgs.lib.removePrefix "@" raw else raw;
    in
    if fileExists file then "--lua-init=@${absPath file}" else null;

  processBlob =
    line:
    let
      rest = pkgs.lib.removePrefix "--blob=" line;
      parts = pkgs.lib.splitString ":" rest;
      blobName = builtins.head parts;
      blobValue = builtins.elemAt parts 1;
    in
    if pkgs.lib.hasPrefix "@" blobValue then
      let
        path = pkgs.lib.removePrefix "@" blobValue;
      in
      if fileExists path then "--blob=${blobName}:@${absPath path}" else null
    else
      line;

  processFileArg =
    prefix: argName: line:
    let
      file = pkgs.lib.removePrefix "${prefix}=" line;
    in
    if fileExists file then "${argName}=${absPath file}" else null;

  processHostlist = processFileArg "--hostlist" "--hostlist";
  processHostlistExclude = processFileArg "--hostlist-exclude" "--hostlist-exclude";
  processIpset = processFileArg "--ipset" "--ipset";
  processIpsetExclude = processFileArg "--ipset-exclude" "--ipset-exclude";

  processLine =
    line:
    if line == "" then
      null
    else if pkgs.lib.hasPrefix "#" line then
      null
    else if pkgs.lib.hasPrefix "--lua-init=" line then
      processLuaInit line
    else if pkgs.lib.hasPrefix "--blob=" line then
      processBlob line
    else if pkgs.lib.hasPrefix "--hostlist=" line then
      processHostlist line
    else if pkgs.lib.hasPrefix "--hostlist-exclude=" line then
      processHostlistExclude line
    else if pkgs.lib.hasPrefix "--ipset=" line then
      processIpset line
    else if pkgs.lib.hasPrefix "--ipset-exclude=" line then
      processIpsetExclude line
    else
      line;

  presetName = "Preset X v2 (game filter).txt";
  presetContent = "${magiskZapret2}/zapret2/presets/${presetName}";
  presetArgs = builtins.concatStringsSep " " (
    pkgs.lib.filter (x: x != null) (map processLine (pkgs.lib.splitString "\n" presetContent))
  );

  queueNum = 200;
in
{
  networking.firewall.extraCommands = ''
    ip46tables \
      -t mangle \
      -I POSTROUTING \
      -p tcp \
      -m multiport \
      --dports 80,443,1024:65535 \
      -m connbytes \
      --connbytes-dir=original \
      --connbytes-mode=packets \
      --connbytes 1:6 \
      -m mark ! \
      --mark 0x40000000/0x40000000 \
      -j NFQUEUE \
      --queue-num ${toString queueNum} \
      --queue-bypass

    ip46tables \
      -t mangle \
      -A POSTROUTING \
      -p udp \
      -m multiport \
      --dports 443,50000:50100,1024:65535 \
      -m mark ! \
      --mark 0x40000000/0x40000000 \
      -j NFQUEUE \
      --queue-num ${toString queueNum} \
      --queue-bypass
  '';

  systemd.services.zapret2 = {
    description = "zapret2 DPI bypass service";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];

    serviceConfig = {
      ExecStart = ''
        ${zapret2WithData}/bin/nfqws2 ${presetArgs} \
          --qnum=${toString queueNum} \
          --pidfile=/run/zapret2.pid
      '';
      Type = "simple";
      Restart = "always";
      RuntimeMaxSec = "1h";
      PIDFile = "/run/zapret2.pid";

      DevicePolicy = "closed";
      KeyringMode = "private";
      PrivateTmp = true;
      PrivateMounts = true;
      ProtectHome = true;
      ProtectHostname = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectSystem = "strict";
      ProtectProc = "invisible";
      RemoveIPC = true;
      RestrictNamespaces = true;
      RestrictRealtime = true;
      RestrictSUIDSGID = true;
      SystemCallArchitectures = "native";
    };
  };
}
