{ pkgs, perSystem, ... }:

let
  dmfrproPkgs = with pkgs.nur.repos.dmfrpro; [
    spflashtool5
    spflashtool6
    rkflashtool
    upgrade_tool
  ];
in
{
  home.packages =
    with pkgs;
    [
      android-tools
      picocom
      mtkclient
      perSystem.penumbra.default
    ]
    ++ dmfrproPkgs;
}
