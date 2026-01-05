{ ... }:

{
  programs.zsh.enable = true;
  services.envfs.enable = true;
  programs.nix-ld.enable = true;

  environment.variables = {
    EDITOR = "nano";
    VISUAL = "nano";
  };
}
