{ pkgs, ... }:

{
  home.packages = with pkgs; [
    docker
    docker-credential-helpers
  ];
}
