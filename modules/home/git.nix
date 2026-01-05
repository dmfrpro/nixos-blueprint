{
  pkgs,
  secrets,
  ...
}:

let
  includes = [
    {
      condition = "gitdir:~/Work/**";
      contents = {
        user = {
          name = secrets.omp.fullname;
          email = secrets.omp.email;
          signingKey = secrets.omp.keys.gpg.signing;
        };

        commit.gpgSign = true;

        url = {
          "ssh://git@${secrets.omp.domains.git}".insteadOf = "https://${secrets.omp.domains.git}";
          "ssh://git@${secrets.omp.domains.os-git}".insteadOf = "https://${secrets.omp.domains.os-git}";
          "https://github.com".insteadOf = "git://github.com";
        };
      };
    }
  ];

  git-libsecret = "${pkgs.git.override { withLibsecret = true; }}";
in
{
  programs.git = {
    enable = true;
    lfs.enable = true;

    settings = {
      user.name = secrets.personal.fullname;
      user.email = secrets.personal.email;

      credential.helper = "${git-libsecret}/bin/git-credential-libsecret";

      url = {
        "ssh://git@github.com".insteadOf = "https://github.com";
      };
    };

    signing = {
      key = secrets.personal.keys.gpg.signing;
      signByDefault = true;
    };

    includes = includes;
  };

  programs.difftastic.enable = true;
}
