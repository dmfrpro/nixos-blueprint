{
  config,
  lib,
  secrets,
  ...
}:

let
  omp_priv = "${config.home.homeDirectory}/.ssh/omp";
  personal_priv = "${config.home.homeDirectory}/.ssh/personal";

  mkHost = domain: keyFile: {
    "${domain}" = {
      AddKeysToAgent = "yes";
      IdentitiesOnly = "yes";
      IdentityFile = keyFile;
      PreferredAuthentications = "publickey";
      IgnoreUnknown = "WarnWeakCrypto";
      WarnWeakCrypto = "no-pq-kex";
    };
  };

  settings = lib.mkMerge [
    (mkHost secrets.omp.domains.git omp_priv)
    (mkHost secrets.omp.domains.os-git omp_priv)
    (mkHost "github.com" personal_priv)
    (mkHost "gitlab.com" personal_priv)
    {
      "device" = {
        User = "defaultuser";
        Hostname = "192.168.2.15";
        UserKnownHostsFile = "/dev/null";
        StrictHostKeyChecking = "no";
      };

      "device-root" = {
        User = "root";
        Hostname = "192.168.2.15";
        UserKnownHostsFile = "/dev/null";
        StrictHostKeyChecking = "no";
      };

      "omp-pc" = {
        User = "${secrets.omp.username}";
        Hostname = "${secrets.omp.domains.omp-pc}";
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
    inherit settings;
  };

  home.file = {
    # home-manager wrongly thinks it doesn't manage
    # (and thus shouldn't clobber) this file due to the activation script
    ".ssh/config".force = true;
  };

  home.activation = {
    # https://github.com/nix-community/home-manager/issues/322
    fixSshPermissions = lib.hm.dag.entryAfter [ "linkGeneration" ] ''
      run install -d -m 0700 "$HOME/.ssh"
      if [ -L "$HOME/.ssh/config" ]; then
        src="$(readlink -f "$HOME/.ssh/config")"
        run rm -f "$HOME/.ssh/config"
        run install -m 0600 "$src" "$HOME/.ssh/config"
      fi
    '';
  };
}
