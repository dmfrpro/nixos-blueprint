{ ... }:

{
  programs.zsh.enable = true;

  environment.variables = {
    EDITOR = "nano";
    VISUAL = "nano";
  };
}
