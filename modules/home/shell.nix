{ ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      cd = "z";
      ls = "eza";
      cat = "bat";
    };
  };

  programs.zsh.oh-my-zsh = {
    enable = true;
    theme = "macovsky";
    plugins = [
      "direnv"
      "docker"
      "git"
      "gpg-agent"
      "history"
      "history-substring-search"
      "repo"
      "ssh"
      "fzf"
    ];
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;

    config = {
      warn_timeout = "0s";
      hide_env_diff = true;
    };
  };

  programs.eza = {
    enable = true;
    git = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };

  programs.bat = {
    enable = true;
    config = {
      map-syntax = [
        "*.h:cpp"
        "*.ignore:.gitignore"
        "*.conf:INI"
      ];
    };
  };
}
