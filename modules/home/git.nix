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

        color.ui = "auto";
      };
    }
  ];

  git-libsecret = "${pkgs.git.override { withLibsecret = true; }}";

  difft-tab-aware = pkgs.writeShellScriptBin "difft-tab-aware" ''
    tab_width=4

    for arg in "$@"; do
      case "$arg" in
        -*) continue ;;
      esac

      case "$arg" in
        *.c|*.h)
          tab_width=8
          break
          ;;
        *.nix)
          tab_width=2
          break
          ;;
      esac
    done

    new_args=()
    inserted=false
    for arg in "$@"; do
      if [[ "$inserted" == false && "$arg" != -* ]]; then
        new_args+=(--tab-width "$tab_width")
        inserted=true
      fi
      new_args+=("$arg")
    done

    if [[ "$inserted" == false ]]; then
      new_args+=(--tab-width "$tab_width")
    fi

    exec ${pkgs.difftastic}/bin/difft "''${new_args[@]}"
  '';
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

      color.ui = "auto";
    };

    signing = {
      key = secrets.personal.keys.gpg.signing;
      signByDefault = true;
    };

    includes = includes;
  };

  programs.difftastic = {
    enable = true;
    git.enable = true;
  };

  programs.lazygit = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    shellWrapperName = "lg";

    settings = {
      gui = {
        tabWidth = 4;
        filterMode = "fuzzy";
      };

      git.pagers = [
        {
          externalDiffCommand = "${difft-tab-aware}/bin/difft-tab-aware --color=always";
        }
      ];

      commit = {
        signoff = true;
      };
    };
  };

  home.packages = [ difft-tab-aware ];
}
