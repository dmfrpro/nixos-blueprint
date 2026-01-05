{
  config,
  lib,
  secrets,
  ...
}:
let
  omp_priv = "${config.home.homeDirectory}/.ssh/omp";
  personal_priv = "${config.home.homeDirectory}/.ssh/personal";

  mkMatchBlock = domain: keyFile: {
    "${domain}" = {
      addKeysToAgent = "yes";
      identitiesOnly = true;
      identityFile = keyFile;
      extraOptions = {
        PreferredAuthentications = "publickey";
      };
    };
  };

  matchBlocks = lib.mkMerge [
    (mkMatchBlock secrets.omp.domains.git omp_priv)
    (mkMatchBlock secrets.omp.domains.os-git omp_priv)
    (mkMatchBlock "github.com" personal_priv)
    (mkMatchBlock "gitlab.com" personal_priv)
    {
      "device" = {
        user = "defaultuser";
        hostname = "192.168.2.15";
        userKnownHostsFile = "/dev/null";
        extraOptions = {
          StrictHostKeyChecking = "no";
        };
      };

      "omp-pc" = {
        user = "${secrets.omp.username}";
        hostname = "${secrets.omp.domains.omp-pc}";
      };
    }
  ];
in
{
  home.file.".ssh/omp" = {
    text = secrets.omp.keys.ssh.private;
  };

  home.file.".ssh/omp.pub" = {
    text = secrets.omp.keys.ssh.public;
  };

  home.file.".ssh/personal" = {
    text = secrets.personal.keys.ssh.private;
  };

  home.file.".ssh/personal.pub" = {
    text = secrets.personal.keys.ssh.public;
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = matchBlocks;
  };
}
