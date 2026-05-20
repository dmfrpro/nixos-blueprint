{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    shellAliases = {
      ls = "eza";
      cat = "bat";
    };

    initContent = ''
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^[[5C' forward-word
      bindkey '^[[5D' backward-word
      bindkey '^[Oc' forward-word
      bindkey '^[Od' backward-word
    '';
  };

  programs.oh-my-posh = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    useTheme = "stelbent-compact.minimal";
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    silent = true;

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

  programs.nh = {
    enable = true;
    flake = "${config.home.homeDirectory}/nixos-blueprint";
  };
}
